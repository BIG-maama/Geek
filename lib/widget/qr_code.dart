import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sensors_plus/sensors_plus.dart';

class QRScannerPage extends StatelessWidget {
  final void Function(String) onCodeScanned;

  const QRScannerPage({Key? key, required this.onCodeScanned})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("امسح الرمز")),
      child: SafeArea(
        child: MobileScanner(
          onDetect: (BarcodeCapture capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes.first.rawValue;
              if (code != null) {
                onCodeScanned(code);
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ),
    );
  }
}

class ShakeDetectorService {
  final VoidCallback onShake;
  final double threshold;
  StreamSubscription? _subscription;

  ShakeDetectorService({required this.onShake, this.threshold = 15.0});

  void start() {
    _subscription = accelerometerEvents.listen((event) {
      final double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > threshold) {
        onShake();
      }
    });
  }

  void stop() {
    _subscription?.cancel();
  }
}
