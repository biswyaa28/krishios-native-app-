import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show debugPrint, compute;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:onnxruntime_v2/onnxruntime_v2.dart';
import 'package:image/image.dart' as img_lib;
import '../models/ai_engine_result.dart';
import 'ai_engine.dart';

class _PreprocessedBuffers {
  final Float32List detFloatBuffer;
  final Float32List classFloatBuffer;
  _PreprocessedBuffers(this.detFloatBuffer, this.classFloatBuffer);
}

_PreprocessedBuffers? _preprocessImageBuffers(Uint8List bytes) {
  final img = img_lib.decodeImage(bytes);
  if (img == null) return null;

  // 1. Leaf Detector Buffer (416x416)
  final imgDetResized = img_lib.copyResize(img, width: 416, height: 416);
  final detFloatBuffer = Float32List(1 * 3 * 416 * 416);
  for (int y = 0; y < 416; y++) {
    for (int x = 0; x < 416; x++) {
      final pixel = imgDetResized.getPixel(x, y);
      detFloatBuffer[0 * 416 * 416 + y * 416 + x] = pixel.r / 255.0;
      detFloatBuffer[1 * 416 * 416 + y * 416 + x] = pixel.g / 255.0;
      detFloatBuffer[2 * 416 * 416 + y * 416 + x] = pixel.b / 255.0;
    }
  }

  // 2. Classification Buffer (224x224)
  final imgResized = img_lib.copyResize(img, width: 224, height: 224);
  final classFloatBuffer = Float32List(1 * 3 * 224 * 224);
  const mean = [0.485, 0.456, 0.406];
  const std = [0.229, 0.224, 0.225];

  for (int y = 0; y < 224; y++) {
    for (int x = 0; x < 224; x++) {
      final pixel = imgResized.getPixel(x, y);
      double r = (pixel.r / 255.0 - mean[0]) / std[0];
      double g = (pixel.g / 255.0 - mean[1]) / std[1];
      double b = (pixel.b / 255.0 - mean[2]) / std[2];

      classFloatBuffer[0 * 224 * 224 + y * 224 + x] = r;
      classFloatBuffer[1 * 224 * 224 + y * 224 + x] = g;
      classFloatBuffer[2 * 224 * 224 + y * 224 + x] = b;
    }
  }

  return _PreprocessedBuffers(detFloatBuffer, classFloatBuffer);
}

class OnDeviceOnnxEngine implements AIEngine {
  OrtSession? _classifierSession;
  OrtSession? _detectorSession;
  List<String> _classNames = [];
  bool _isReady = false;

  @override
  Future<void> initialize() async {
    try {
      // 1. Initialize ONNX runtime environment FFI bindings
      OrtEnv.instance.init();

      // 2. Load model binary arrays from Flutter bundle assets
      final classifierData = await rootBundle.load('assets/onnx/classifier.onnx');
      final detectorData = await rootBundle.load('assets/onnx/leaf_detector.onnx');
      final labelsData = await rootBundle.loadString('assets/onnx/labels.json');

      _classNames = List<String>.from(jsonDecode(labelsData) as List);

      final sessionOptions = OrtSessionOptions();
      _classifierSession = OrtSession.fromBuffer(
        classifierData.buffer.asUint8List(classifierData.offsetInBytes, classifierData.lengthInBytes),
        sessionOptions,
      );
      _detectorSession = OrtSession.fromBuffer(
        detectorData.buffer.asUint8List(detectorData.offsetInBytes, detectorData.lengthInBytes),
        sessionOptions,
      );

      _isReady = true;
    } catch (e) {
      _isReady = false;
      throw Exception('Failed to load local ONNX sessions: $e');
    }
  }

  @override
  Future<AIEngineResult> processImage(dynamic imageFile) async {
    if (!_isReady || _classifierSession == null || _detectorSession == null) {
      return AIEngineResult.failure('ONNX Session not initialized.');
    }

    try {
      final Uint8List bytes;
      if (imageFile is Uint8List) {
        bytes = imageFile;
      } else if (imageFile is XFile) {
        bytes = await imageFile.readAsBytes();
      } else if (imageFile is File) {
        bytes = await imageFile.readAsBytes();
      } else if (imageFile is String) {
        bytes = await File(imageFile).readAsBytes();
      } else {
        return AIEngineResult.failure('Unsupported image file type: ${imageFile.runtimeType}');
      }

      // 1. Offload image decoding & preprocessing to background Isolate
      final preprocessed = await compute(_preprocessImageBuffers, bytes);
      if (preprocessed == null) {
        return AIEngineResult.failure('Failed to decode input leaf image.');
      }

      // --- Leaf Detection Stage ---
      final detInputTensor = OrtValueTensor.createTensorWithDataList(
        preprocessed.detFloatBuffer,
        [1, 3, 416, 416],
      );

      final runOptions = OrtRunOptions();
      final detInputs = {'images': detInputTensor};
      final detOutputs = _detectorSession!.run(runOptions, detInputs);
      detInputTensor.release();

      if (detOutputs.isEmpty) {
        return AIEngineResult.failure('Leaf detection forward pass returned empty outputs.');
      }

      final rawDetOutput = detOutputs[0]?.value as List<dynamic>;
      if (rawDetOutput.isEmpty || (rawDetOutput[0] as List<dynamic>).isEmpty) {
        return AIEngineResult.failure('Failed to parse leaf detection results.');
      }

      final detections = rawDetOutput[0] as List<dynamic>;
      final xCenters = List<dynamic>.from(detections[0] as List);
      final yCenters = List<dynamic>.from(detections[1] as List);
      final widths = List<dynamic>.from(detections[2] as List);
      final heights = List<dynamic>.from(detections[3] as List);
      final confidences = List<dynamic>.from(detections[4] as List);

      final List<_BBox> candidates = [];
      for (int i = 0; i < 3549; i++) {
        final double conf = (confidences[i] as num).toDouble();
        if (conf >= 0.45) {
          final double cx = (xCenters[i] as num).toDouble();
          final double cy = (yCenters[i] as num).toDouble();
          final double w = (widths[i] as num).toDouble();
          final double h = (heights[i] as num).toDouble();

          final double xMin = cx - w / 2.0;
          final double yMin = cy - h / 2.0;
          final double xMax = cx + w / 2.0;
          final double yMax = cy + h / 2.0;

          candidates.add(_BBox(xMin, yMin, xMax, yMax, conf));
        }
      }

      // Apply NMS (Non-Maximum Suppression)
      candidates.sort((a, b) => b.confidence.compareTo(a.confidence));
      final List<_BBox> kept = [];
      for (final box in candidates) {
        bool keep = true;
        for (final keptBox in kept) {
          final double iou = _calculateIoU(box, keptBox);
          if (iou >= 0.45) {
            keep = false;
            break;
          }
        }
        if (keep) {
          kept.add(box);
        }
      }

      debugPrint('[ONNX Local Engine] Leaf Detection - Candidates: ${candidates.length}, Kept: ${kept.length}');
      if (kept.isNotEmpty) {
        final singleLeaf = kept.first;
        final double areaRatio = ((singleLeaf.xMax - singleLeaf.xMin) / 416.0) * ((singleLeaf.yMax - singleLeaf.yMin) / 416.0);
        debugPrint('[ONNX Local Engine] Leaf Bounding Box: [${singleLeaf.xMin.toStringAsFixed(1)}, ${singleLeaf.yMin.toStringAsFixed(1)}, ${singleLeaf.xMax.toStringAsFixed(1)}, ${singleLeaf.yMax.toStringAsFixed(1)}], conf: ${singleLeaf.confidence.toStringAsFixed(3)}, areaRatio: ${areaRatio.toStringAsFixed(3)}');
      }

      if (kept.isEmpty) {
        return AIEngineResult.failure('No crop leaf detected.');
      }
      if (kept.length > 1) {
        return AIEngineResult.failure('Please capture one leaf (multiple leaves detected).');
      }

      final singleLeaf = kept.first;
      final double areaRatio = ((singleLeaf.xMax - singleLeaf.xMin) / 416.0) * ((singleLeaf.yMax - singleLeaf.yMin) / 416.0);
      if (areaRatio < 0.10) {
        return AIEngineResult.failure('Move closer to the leaf (leaf covers less than 10% of the frame).');
      }

      // --- Disease Classification Stage ---
      // Create OrtValueTensor mapping the input shape from preprocessed buffer
      final inputTensor = OrtValueTensor.createTensorWithDataList(
        preprocessed.classFloatBuffer,
        [1, 3, 224, 224],
      );

      final inputs = {'input': inputTensor};
      final outputs = _classifierSession!.run(runOptions, inputs);
      inputTensor.release();

      if (outputs.isEmpty) {
        return AIEngineResult.failure('ONNX forward pass returned empty outputs.');
      }

      // Retrieve output tensor values
      final outputTensor = outputs[0]?.value as List<List<double>>?;
      if (outputTensor == null || outputTensor.isEmpty) {
        return AIEngineResult.failure('Output logits could not be casted.');
      }

      // ArgMax calculations to resolve diagnosis prediction text
      final logits = outputTensor[0];
      int maxIdx = 0;
      double maxVal = logits[0];
      for (int i = 1; i < logits.length; i++) {
        if (logits[i] > maxVal) {
          maxVal = logits[i];
          maxIdx = i;
        }
      }

      // Compute exact softmax confidence score to match PyTorch backend
      double maxLogit = logits[0];
      for (int i = 1; i < logits.length; i++) {
        if (logits[i] > maxLogit) {
          maxLogit = logits[i];
        }
      }

      final exps = logits.map((val) => math.exp(val - maxLogit)).toList();
      final sumExp = exps.reduce((a, b) => a + b);
      final probabilities = exps.map((val) => val / sumExp).toList();

      final confidence = probabilities[maxIdx];
      final label = maxIdx < _classNames.length ? _classNames[maxIdx] : 'Unknown';

      // Log the prediction array and probabilities for local debugging
      debugPrint('[ONNX Local Engine] Predicted Index: $maxIdx, Label: $label, Softmax Confidence: ${(confidence * 100).toStringAsFixed(1)}%');

      double healthScoreVal = 100.0;
      if (!label.toLowerCase().contains('healthy')) {
        final nameLower = label.toLowerCase();
        double impact = 0.3;
        if (nameLower.contains('late blight') ||
            nameLower.contains('black rot') ||
            nameLower.contains('yellow leaf curl') ||
            nameLower.contains('mosaic virus') ||
            nameLower.contains('greening')) {
          impact = 0.8;
        } else if (nameLower.contains('rust') ||
            nameLower.contains('scab') ||
            nameLower.contains('powdery mildew') ||
            nameLower.contains('bacterial spot') ||
            nameLower.contains('early blight')) {
          impact = 0.5;
        }
        healthScoreVal = 100.0 - (confidence * impact * 100.0);
      } else {
        healthScoreVal = confidence * 100.0;
      }

      return AIEngineResult(
        prediction: label,
        confidence: confidence,
        healthScore: healthScoreVal,
      );
    } catch (e) {
      return AIEngineResult.failure('ONNX Inference session runtime error: $e');
    }
  }

  @override
  bool get isReady => _isReady;

  @override
  void dispose() {
    _classifierSession?.release();
    _detectorSession?.release();
    _isReady = false;
  }
}

class _BBox {
  final double xMin;
  final double yMin;
  final double xMax;
  final double yMax;
  final double confidence;

  _BBox(this.xMin, this.yMin, this.xMax, this.yMax, this.confidence);
}

double _calculateIoU(_BBox boxA, _BBox boxB) {
  final double xA = math.max(boxA.xMin, boxB.xMin);
  final double yA = math.max(boxA.yMin, boxB.yMin);
  final double xB = math.min(boxA.xMax, boxB.xMax);
  final double yB = math.min(boxA.yMax, boxB.yMax);

  final double interArea = math.max(0.0, xB - xA) * math.max(0.0, yB - yA);
  if (interArea == 0.0) return 0.0;

  final double areaA = (boxA.xMax - boxA.xMin) * (boxA.yMax - boxA.yMin);
  final double areaB = (boxB.xMax - boxB.xMin) * (boxB.yMax - boxB.yMin);

  return interArea / (areaA + areaB - interArea);
}
