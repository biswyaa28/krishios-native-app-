import 'dart:typed_data';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img_lib;
import 'scan_result_screen.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import '../../presentation/providers/scan_provider.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../widgets/corner_bracket.dart';
import '../widgets/scanning_line.dart';
import 'package:krishios/shared/presentation/widgets/krishi_mobile_header.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';

Uint8List _compressImageTask(Uint8List rawBytes) {
  final image = img_lib.decodeImage(rawBytes);
  if (image == null) return rawBytes;
  img_lib.Image resized = image;
  if (image.width > 1080 || image.height > 1080) {
    if (image.width > image.height) {
      resized = img_lib.copyResize(image, width: 1080);
    } else {
      resized = img_lib.copyResize(image, height: 1080);
    }
  }
  return Uint8List.fromList(img_lib.encodeJpg(resized, quality: 85));
}

class CropScanScreen extends ConsumerStatefulWidget {
  final bool? showBackButton;
  const CropScanScreen({super.key, this.showBackButton});

  @override
  ConsumerState<CropScanScreen> createState() => _CropScanScreenState();
}

class _CropScanScreenState extends ConsumerState<CropScanScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String _statusMessage = '';
  String? _cameraError;
  bool _isFlashOn = false;
  Offset? _focusPoint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCameraWithPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _isCameraInitialized = false;
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCameraWithPermission() async {
    final hasPermission = await _requestCameraPermission();
    if (!hasPermission) return;
    await _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameraError = null;
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final controller = CameraController(
          _cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await controller.initialize();
        if (mounted) {
          setState(() {
            _controller = controller;
            _isCameraInitialized = true;
          });
        } else {
          await controller.dispose();
        }
      } else {
        if (mounted) {
          setState(() {
            _cameraError = 'No cameras available on this device.';
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

  Future<void> _processImage(XFile xfile) async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Optimizing & uploading image...';
    });

    try {
      String downloadUrl = '';
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? 'guest-user';
      final scanId = FirebaseFirestore.instance.collection('scans').doc().id;

      // 1. Compress image in background Isolate & Upload to Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('scans')
            .child(userId)
            .child('$scanId.jpg');

        final rawBytes = await xfile.readAsBytes();
        final compressedBytes = await compute(_compressImageTask, rawBytes);

        await storageRef.putData(
          compressedBytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        downloadUrl = await storageRef.getDownloadURL();
      } catch (e) {
        debugPrint('[WARNING] Firebase Storage upload failed: $e. Using local path.');
        downloadUrl = xfile.path;
      }

      setState(() {
        _statusMessage = 'Diagnosing leaf pathology...';
      });

      // 2. Fetch Geolocation (properly awaits the FutureProvider)
      double? lat;
      double? lon;
      try {
        final pos = await ref.read(positionProvider.future);
        if (pos != null) {
          lat = pos.latitude;
          lon = pos.longitude;
        }
      } catch (_) {
        // Location unavailable — proceed without it
      }

      // 3. Call shared AI engine (auto-routes between cloud and on-device)
      final engine = ref.read(aiEngineManagerProvider);
      final aiResult = await engine.processImage(xfile);

      if (!aiResult.success) {
        debugPrint('[WARNING] AI engine diagnosis failed: ${aiResult.errorMessage}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Diagnosis failed: ${aiResult.errorMessage}'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        setState(() => _isProcessing = false);
        return;
      }

      final diagnosis = aiResult.prediction;
      final confidence = aiResult.confidence;
      final healthScore = aiResult.healthScore;

      // Extract crop classification
      final words = diagnosis.split(' ');
      final cropName = words.isNotEmpty ? words.first : 'Crop';
      final disease = words.length > 1 ? words.sublist(1).join(' ') : 'Healthy';

      // Treatment lookup by disease name

      final treatmentObj = TranslationService.translateTreatment(disease, 'en');
      final String treatment = treatmentObj.directTreatment;

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

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final nextMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _controller!.setFlashMode(nextMode);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('[WARNING] Flash toggle error: $e');
    }
  }

  Future<void> _onTapPreview(TapDownDetails details, BoxConstraints constraints) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    try {
      await _controller!.setFocusPoint(offset);
      await _controller!.setExposurePoint(offset);
      setState(() {
        _focusPoint = details.localPosition;
      });
      HapticFeedback.selectionClick();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _focusPoint = null);
      });
    } catch (e) {
      debugPrint('[WARNING] Tap focus error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Camera Permission Needed'),
            content: const Text(
              'Camera access is required for real-time leaf diagnosis. Please enable it in App Settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
      return false;
    }
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<void> _capturePhoto() async {
    HapticFeedback.mediumImpact();
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
      await _processImage(file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera capture error: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    HapticFeedback.mediumImpact();
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        await _processImage(file);
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
    final activeLang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KrishiMobileHeader(
                subtitle: TranslationService.translate('scan_title', activeLang),
                showBackButton: widget.showBackButton,
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
                              ? LayoutBuilder(
                                  builder: (context, constraints) {
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTapDown: (details) => _onTapPreview(details, constraints),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CameraPreview(_controller!),
                                          if (_focusPoint != null)
                                            Positioned(
                                              left: _focusPoint!.dx - 24,
                                              top: _focusPoint!.dy - 24,
                                              child: Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.amber, width: 2),
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: Material(
                                              color: Colors.black54,
                                              shape: const CircleBorder(),
                                              child: IconButton(
                                                icon: Icon(
                                                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                                  color: _isFlashOn ? Colors.amber : Colors.white70,
                                                ),
                                                onPressed: _toggleFlash,
                                                tooltip: 'Toggle Flash',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
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
                        CircularProgressIndicator(color: AppColors.primary),
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
