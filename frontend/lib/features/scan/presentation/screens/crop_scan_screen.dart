import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'scan_result_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import '../../presentation/providers/scan_provider.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../widgets/corner_bracket.dart';
import '../widgets/scanning_line.dart';
import '../../data/treatment_data.dart';

class CropScanScreen extends ConsumerStatefulWidget {
  const CropScanScreen({super.key});

  @override
  ConsumerState<CropScanScreen> createState() => _CropScanScreenState();
}

class _CropScanScreenState extends ConsumerState<CropScanScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String _statusMessage = '';
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _initCameraWithPermission();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCameraWithPermission() async {
    if (!await _requestCameraPermission()) return;
    await _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameraError = null;
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('[WARNING] Camera could not initialize: $e');
      if (mounted) {
        setState(() {
          _cameraError = e.toString();
        });
      }
    }
  }

  Future<void> _processImage(String imagePath) async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Uploading crop image...';
    });

    try {
      final File imageFile = File(imagePath);
      String downloadUrl = '';
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? 'guest-user';
      final scanId = FirebaseFirestore.instance.collection('scans').doc().id;

      // 1. Upload to Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('scans')
            .child(userId)
            .child('$scanId.jpg');
        
        await storageRef.putFile(imageFile);
        downloadUrl = await storageRef.getDownloadURL();
      } catch (e) {
        debugPrint('[WARNING] Firebase Storage upload failed: $e. Using local path.');
        downloadUrl = imagePath;
      }

      setState(() {
        _statusMessage = 'Diagnosing leaf pathology...';
      });

      // 2. Fetch Geolocation
      double? lat;
      double? lon;
      final posAsync = ref.read(positionProvider);
      if (posAsync is AsyncData<Position?> && posAsync.value != null) {
        lat = posAsync.value!.latitude;
        lon = posAsync.value!.longitude;
      }

      // 3. Call AI REST API Backend
      String diagnosis = 'Unknown';
      double confidence = 0.0;
      double? healthScore;

      final override = ApiConstants.overrideHost;
      final host = override ?? (defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost');
      final uri = Uri.parse(ApiConstants.scanBaseUrl.replaceFirst('localhost', host)).replace(path: '/predict');

      try {
        final request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath('file', imagePath, contentType: MediaType('image', 'jpeg')));

        final streamedResponse = await request.send().timeout(const Duration(seconds: 12));
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          diagnosis = data['prediction'] ?? 'Unknown crop state';
          confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;
          healthScore = (data['health_score'] as num?)?.toDouble();
        } else {
          throw Exception('Status code: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('[WARNING] AI API host unreachable: $e.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not reach AI backend. Ensure the server is running.')),
          );
        }
        setState(() => _isProcessing = false);
        return;
      }

      // Extract crop classification
      final words = diagnosis.split(' ');
      final cropName = words.isNotEmpty ? words.first : 'Crop';
      final disease = words.length > 1 ? words.sublist(1).join(' ') : 'Healthy';

      // Treatment lookup by disease name

      String treatment = 'Inspect plant thoroughly. Isolate if symptoms worsen. Consult local extension service.';
      for (final entry in treatmentMap.entries) {
        if (disease.toLowerCase().contains(entry.key)) {
          treatment = entry.value;
          break;
        }
      }

      final scanResult = ScanResult(
        id: scanId,
        cropName: cropName,
        fieldName: 'Unnamed Field',
        diagnosis: disease,
        healthScore: healthScore ?? (disease.toLowerCase().contains('healthy') ? 100.0 : (1.0 - confidence) * 100.0),
        scannedAt: DateTime.now(),
        imagePath: downloadUrl,
        confidence: confidence,
        treatment: treatment,
        latitude: lat,
        longitude: lon,
        userId: userId,
      );

      // 4. Save to ScanRepository
      await ref.read(scanRepositoryProvider).addScan(scanResult);

      // Force Riverpod cache reload
      ref.invalidate(scanHistoryProvider);
      ref.invalidate(averageHealthProvider);
      ref.invalidate(weeklyScanCountProvider);

      if (mounted) {
        // 5. Route to detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanResultScreen(scan: scanResult),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Processing error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) return true;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required to capture photos.')),
      );
    }
    return false;
  }

  Future<void> _capturePhoto() async {
    if (!await _requestCameraPermission()) return;
    if (_controller == null || !_controller!.value.isInitialized) {
      await _initCamera();
      if (_controller == null || !_controller!.value.isInitialized) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera not available. Please try gallery.')),
          );
        }
        return;
      }
    }
    try {
      final XFile file = await _controller!.takePicture();
      await _processImage(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera capture error: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        await _processImage(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gallery selection error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: AppColors.surface.withValues(alpha: 0.8),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 64,
                      child: Row(
                        children: [
                          const Icon(Icons.agriculture, color: AppColors.primary, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'KrishiOS',
                            style: AppTextStyles.headlineMd.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.help_outline, color: AppColors.onSurface),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  'Identify Crop Disease',
                  style: AppTextStyles.headlineLgMobile,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Text(
                  'Point your camera at the affected leaves or stems for a real-time AI diagnosis.',
                  style: AppTextStyles.bodyMd,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _isCameraInitialized && _controller != null
                              ? CameraPreview(_controller!)
                              : Container(
                                  color: const Color(0xFF1A2A1A),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.videocam_off,
                                            size: 80,
                                            color: Colors.white.withValues(alpha: 0.3)),
                                        const SizedBox(height: 8),
                                        Text(
                                          _cameraError != null
                                              ? 'Camera error: $_cameraError'
                                              : 'Camera preview unavailable. Please use gallery.',
                                          style: AppTextStyles.labelMd
                                              .copyWith(color: Colors.white54),
                                          textAlign: TextAlign.center,
                                        ),
                                        if (_cameraError != null) ...[
                                          const SizedBox(height: 16),
                                          OutlinedButton.icon(
                                            onPressed: _initCamera,
                                            icon: const Icon(Icons.refresh, size: 18),
                                            label: const Text('Retry'),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              side: const BorderSide(color: Colors.white54),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        if (_isCameraInitialized)
                          Center(
                            child: SizedBox(
                              width: 256,
                              height: 256,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    top: 0,
                                    left: 0,
                                    child: CornerBracket(isTop: true, isLeft: true),
                                  ),
                                  const Positioned(
                                    top: 0,
                                    right: 0,
                                    child: CornerBracket(isTop: true, isLeft: false),
                                  ),
                                  const Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: CornerBracket(isTop: false, isLeft: true),
                                  ),
                                  const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CornerBracket(isTop: false, isLeft: false),
                                  ),
                                  const ScanningLine(),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _capturePhoto,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Capture Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          textStyle: AppTextStyles.labelMd,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _isProcessing ? null : _pickFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Upload from Gallery'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.secondaryContainer,
                          foregroundColor: AppColors.onSecondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          side: BorderSide.none,
                          textStyle: AppTextStyles.labelMd,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: AppColors.primary),
                        const SizedBox(height: 16),
                        Text(
                          _statusMessage,
                          style: AppTextStyles.labelMd,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
