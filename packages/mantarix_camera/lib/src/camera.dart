import 'package:camera/camera.dart';
import 'package:mantarix/mantarix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/camera.dart';

class CameraControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final MantarixControlBackend backend;

  const CameraControl(
      {super.key,
      required this.parent,
      required this.control,
      required this.children,
      required this.parentDisabled,
      required this.backend});

  @override
  State<CameraControl> createState() => _CameraControlState();
}

class _CameraControlState extends State<CameraControl> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;

  Future<List<CameraDescription>> _initCameras() async {
    _cameras = await availableCameras();
    var enableAudio = widget.control.attrBool("enableAudio", true)!;
    var resolutionPreset = parseResolutionPreset(widget.control.attrString("resolutionPreset"));
    var imageFormatGroup = parseImageFormatGroup(widget.control.attrString("imageFormatGroup"));
    // setState(() {
    _controller = CameraController(
      _cameras![_selectedCameraIndex],
      resolutionPreset ?? ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: imageFormatGroup,
    );
    // });
    return _cameras!;
  }

  @override
  void initState() {
    super.initState();
    _initCameraAndController();
  }

  Future<void> _initCameraAndController() async {
    try {
      var cameras = await _initCameras();
      debugPrint("Camera.initState($cameras)");
      await _controller?.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (e is CameraException) {
        debugPrint("CAMERA ERROR: ${e.code} = ${e.description}");
      }
    }

    _controller?.addListener(() {
      debugPrint("CAMERA NOTIFIER: ${_controller?.value}");
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<XFile?> captureImage() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final XFile? imageFile = await _controller?.takePicture();
        debugPrint("CAMERA IMAGE imageFile.path: ${imageFile?.path}");
        return imageFile;
      } catch (e) {
        debugPrint("CAMERA ERROR: $e");
      }
    }
    return null;
  }

  void startRecording() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller?.startVideoRecording();
      } catch (e) {
        debugPrint("VIDEO ERROR starting video recording: $e");
      }
    }
  }

  Future<XFile?> stopRecording() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      try {
        final XFile? videoFile = await _controller?.stopVideoRecording();
        debugPrint("VIDEO recording stopped. File: ${videoFile?.path}");
        return videoFile;
      } catch (e) {
        debugPrint("VIDEO ERROR stopping video recording: $e");
      }
    }

    return null;
  }

  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    _controller?.dispose();

    try {
      await _initCameraAndController();
    } catch (e) {
      debugPrint("CAMERA SWITCH ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool disabled = widget.control.isDisabled || widget.parentDisabled;
    var exposureMode = widget.control.attrString("exposureMode");
    var exposureOffset = widget.control.attrDouble("exposureOffset");
    var zoomLevel = widget.control.attrDouble("zoomLevel");

    () async {
      if (!kIsWeb && exposureMode != null && parseExposureMode(exposureMode) != null) {
        await _controller?.setExposureMode(parseExposureMode(exposureMode)!);
      }

      if (!kIsWeb && exposureOffset != null) {
        await _controller?.setExposureOffset(exposureOffset);
      }

      if (!kIsWeb && zoomLevel != null) {
        //  && 1.0 <= zoomLevel && zoomLevel <= _controller.getMaxZoomLevel()
        await _controller?.setZoomLevel(zoomLevel);
      }

      widget.backend.subscribeMethods(widget.control.id,
          (methodName, args) async {
        switch (methodName) {
          case "capture_image":
            debugPrint("CAMERA.captureImage()");
            await captureImage();
            break;
          case "start_video_recording":
            debugPrint("CAMERA.startRecording()");
            startRecording();
            return null;
          case "stop_video_recording":
            debugPrint("CAMERA.stopRecording()");
            var output = await stopRecording();
            return output?.path;
          case "switch_camera":
            await switchCamera();
            return null;
          case "initialized":
            debugPrint("CAMERA.initialized()");
            if (_cameras == null || _cameras!.isEmpty) {
              return "0";
            }
            int o = _cameras!.length;
            return "$o";
          default:
            debugPrint("CAMERA unknown method: $methodName");
            break;
        }
        return null;
      });
    }();

    var errorContentCtrls =
        widget.children.where((c) => c.name == "error_content" && c.isVisible);

    var camera =
        _controller != null && (_controller?.value.isInitialized ?? false)
            ? CameraPreview(_controller!)
            : errorContentCtrls.isNotEmpty
                ? createControl(
                    widget.control, errorContentCtrls.first.id, disabled)
                : const ErrorControl("Camera not initialized.");

    debugPrint("Camera build: ${widget.control.id}");

    return constrainedControl(context, camera, widget.parent, widget.control);
  }
}