import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
