import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

class QRScanScreen extends StatefulWidget {
  final Function(String sessionId) onScanned;

  const QRScanScreen({super.key, required this.onScanned});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫描二维码'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              try {
                final data = json.decode(barcode.rawValue!) as Map<String, dynamic>;
                if (data['type'] == 'airword-session' && data['sessionId'] != null) {
                  widget.onScanned(data['sessionId'] as String);
                  Navigator.pop(context);
                  break;
                }
              } catch (e) {
                print('Failed to parse QR code: $e');
              }
            }
          }
        },
      ),
    );
  }
}
