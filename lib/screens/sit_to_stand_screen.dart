// lib/screens/sit_to_stand_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class SitToStandScreen extends StatefulWidget {
  static const routeName = '/sit-to-stand';
  const SitToStandScreen({Key? key}) : super(key: key);

  @override
  _SitToStandScreenState createState() => _SitToStandScreenState();
}

class _SitToStandScreenState extends State<SitToStandScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    // 1. Fetch the available cameras.
    final cameras = await availableCameras();

    // 2. Pick the front-facing camera.
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    // 3. Create & initialize the controller.
    _controller = CameraController(
      frontCam,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller!.initialize();

    // 4. Rebuild once initialized.
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sit-to-Stand Test')),
      body:
          _initializeControllerFuture == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Show the live camera preview.
                    return CameraPreview(_controller!);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
    );
  }
}
