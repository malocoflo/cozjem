import 'dart:io';
import 'package:camera/camera.dart' as cam;
import 'package:image_picker/image_picker.dart';

class CameraServiceException implements Exception {
  final String message;
  const CameraServiceException(this.message);
  @override
  String toString() => 'CameraServiceException: $message';
}

class CameraService {
  cam.CameraController? _controller;
  List<cam.CameraDescription> _cameras = [];
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  cam.CameraController? get controller => _controller;

  Future<void> initialize() async {
    try {
      _cameras = await cam.availableCameras();
      if (_cameras.isEmpty) {
        throw const CameraServiceException('Nie znaleziono kamery na urządzeniu.');
      }

      // Prefer back camera
      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == cam.CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = cam.CameraController(
        camera,
        cam.ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      _isInitialized = true;
    } on cam.CameraException catch (e) {
      throw CameraServiceException('Błąd kamery: ${e.description}');
    }
  }

  Future<File> takePicture() async {
    if (_controller == null || !_isInitialized) {
      throw const CameraServiceException('Kamera nie jest zainicjalizowana.');
    }
    try {
      final xFile = await _controller!.takePicture();
      return File(xFile.path);
    } on cam.CameraException catch (e) {
      throw CameraServiceException('Nie udało się zrobić zdjęcia: ${e.description}');
    }
  }

  Future<File?> pickFromGallery() async {
    final picker = ImagePicker();
    try {
      final xFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (xFile == null) return null;
      return File(xFile.path);
    } catch (e) {
      throw CameraServiceException('Nie udało się wybrać zdjęcia z galerii: $e');
    }
  }

  void dispose() {
    _controller?.dispose();
    _isInitialized = false;
  }
}
