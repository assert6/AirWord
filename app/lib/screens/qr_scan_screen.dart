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
              print('=== 扫描到二维码 ===');
              print('原始内容: ${barcode.rawValue}');
              try {
                final data = json.decode(barcode.rawValue!) as Map<String, dynamic>;
                print('解析后: $data');
                if (data['type'] == 'airword-session' && data['sessionId'] != null) {
                  print('✅ Session ID: ${data['sessionId']}');
                  widget.onScanned(data['sessionId'] as String);
                  Navigator.pop(context);
                  break;
                } else {
                  print('❌ 类型不匹配或sessionId为空');
                }
              } catch (e) {
                print('❌ 解析失败: $e');
              }
            }
          }
        },
      ),
    );
  }
}
