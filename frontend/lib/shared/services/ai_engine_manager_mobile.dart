import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;
import 'package:http/http.dart' as http;
import '../models/ai_engine_result.dart';
import 'ai_engine.dart';
import 'on_device_onnx_engine.dart';
import 'remote_api_engine.dart';

enum AIEngineMode {
  auto,
  forceLocal,
  forceCloud,
}

class AIEngineManager extends ChangeNotifier {
  final AIEngine _onnxEngine;
  final AIEngine _apiEngine;
  final Future<bool> Function()? _apiReachabilityCheck;
  final String _host;
  final String _scanBaseUrl;
  AIEngineMode _currentMode = AIEngineMode.auto;
  bool _apiReachable = false;
  String? _initError;

  AIEngineManager({
    required String scanBaseUrl,
    required String host,
    AIEngine? localEngine,
    AIEngine? remoteEngine,
    Future<bool> Function()? apiReachabilityCheck,
  })  : _onnxEngine = localEngine ?? OnDeviceOnnxEngine(),
        _apiEngine = remoteEngine ?? RemoteApiEngine(scanBaseUrl: scanBaseUrl, host: host),
        _apiReachabilityCheck = apiReachabilityCheck,
        _host = host,
        _scanBaseUrl = scanBaseUrl;

  Future<void> initialize() async {
    try {
      debugPrint('[INFO] Initializing On-Device ONNX AI Engine...');
      await _onnxEngine.initialize();
      _initError = null;
      debugPrint('[SUCCESS] Local ONNX engine loaded and ready.');
    } catch (e) {
      debugPrint('[WARNING] ONNX init failed: $e');
      _initError = e.toString();
    }

    // Initialize API engine
    await _apiEngine.initialize();
    
    // Check initial API availability
    _apiReachable = await checkApiReachable();
    notifyListeners();
  }

  Future<bool> checkApiReachable() async {
    if (_apiReachabilityCheck != null) {
      return _apiReachabilityCheck();
    }

    try {
      final cleanHost = _host.trim();
      final resolvedUrl = _scanBaseUrl.replaceFirst('localhost', cleanHost);
      final uri = Uri.parse(resolvedUrl).replace(path: '/health');
      final response = await http.get(uri).timeout(const Duration(milliseconds: 1500));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<AIEngineResult> processImage(dynamic imageFile) async {
    if (_currentMode != AIEngineMode.forceLocal) {
      _apiReachable = await checkApiReachable();
      notifyListeners();
    }

    // 2. Decide engine route
    bool useCloud = false;
    if (_currentMode == AIEngineMode.forceCloud) {
      useCloud = true;
    } else if (_currentMode == AIEngineMode.forceLocal) {
      useCloud = false;
    } else {
      // Auto Mode: Use cloud if reachable, fallback to ONNX local if not
      useCloud = _apiReachable;
    }

    if (useCloud) {
      debugPrint('[ROUTE] Routing prediction request to: Cloud FastAPI');
      final result = await _apiEngine.processImage(imageFile);
      if (result.success) {
        return result;
      }
      debugPrint('[WARNING] Cloud FastAPI routing failed: ${result.errorMessage}. Retrying via local ONNX...');

      if (_onnxEngine.isReady) {
        debugPrint('[ROUTE] Routing fallback request to: Local ONNX Runtime');
        return await _onnxEngine.processImage(imageFile);
      }
      return result;
    } else {
      // Local preferred (forceLocal or auto-offline)
      if (_onnxEngine.isReady) {
        debugPrint('[ROUTE] Routing prediction request to: Local ONNX Runtime');
        return await _onnxEngine.processImage(imageFile);
      }

      // If local ONNX is not ready, fall back to cloud as a last resort (if not forced local)
      if (_currentMode != AIEngineMode.forceLocal) {
        debugPrint('[ROUTE] Routing fallback request to: Cloud FastAPI');
        return await _apiEngine.processImage(imageFile);
      }

      return AIEngineResult.failure('Local ONNX engine is not initialized.');
    }
  }

  AIEngineMode get currentMode => _currentMode;

  bool get apiReachable => _apiReachable;

  String get resolvedBaseUrl {
    final cleanHost = _host.trim();
    return _scanBaseUrl.replaceFirst('localhost', cleanHost);
  }

  void setEngineMode(AIEngineMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  bool get isUsingLocal {
    if (_currentMode == AIEngineMode.forceLocal) return true;
    if (_currentMode == AIEngineMode.forceCloud) return false;
    // Auto mode
    return !_apiReachable;
  }

  String? get initError => _initError;

  @override
  void dispose() {
    _onnxEngine.dispose();
    _apiEngine.dispose();
    super.dispose();
  }
}
