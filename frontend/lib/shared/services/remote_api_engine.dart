import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/ai_engine_result.dart';
import 'ai_engine.dart';

class RemoteApiEngine implements AIEngine {
  final String scanBaseUrl;
  final String host;
  bool _isReady = false;

  RemoteApiEngine({required this.scanBaseUrl, required this.host});

  @override
  Future<void> initialize() async {
    _isReady = true;
  }

  @override
  Future<AIEngineResult> processImage(dynamic imageFile) async {
    final cleanHost = host.trim();
    final resolvedUrl = scanBaseUrl.replaceFirst('localhost', cleanHost);
    final uri = Uri.parse(resolvedUrl).replace(path: '/predict');

    try {
      final String? filePath;
      final Uint8List? bytes;

      if (imageFile is XFile) {
        filePath = imageFile.path;
        bytes = await imageFile.readAsBytes();
      } else if (imageFile is File) {
        filePath = imageFile.path;
        bytes = await imageFile.readAsBytes();
      } else if (imageFile is String) {
        filePath = imageFile;
        bytes = await File(imageFile).readAsBytes();
      } else if (imageFile is Uint8List) {
        filePath = null;
        bytes = imageFile;
      } else {
        return AIEngineResult.failure('Unsupported image file type: ${imageFile.runtimeType}');
      }

      final http.MultipartFile multipartFile;
      if (kIsWeb || filePath == null || filePath.isEmpty) {
        multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes!,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
      } else {
        multipartFile = await http.MultipartFile.fromPath(
          'file',
          filePath,
          contentType: MediaType('image', 'jpeg'),
        );
      }

      final request = http.MultipartRequest('POST', uri)
        ..files.add(multipartFile);

      final streamedResponse = await request.send().timeout(const Duration(seconds: 12));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AIEngineResult(
          prediction: data['prediction'] ?? 'Unknown crop state',
          confidence: (data['confidence'] as num?)?.toDouble() ?? 0.0,
          healthScore: (data['health_score'] as num?)?.toDouble(),
          metadata: data['metadata'] as Map<String, dynamic>?,
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final detailMsg = data['detail'] ?? 'Validation failed.';
        return AIEngineResult.failure(detailMsg);
      } else {
        return AIEngineResult.failure('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      return AIEngineResult.failure('Failed to reach backend server: $e');
    }
  }

  @override
  bool get isReady => _isReady;

  @override
  void dispose() {}
}
