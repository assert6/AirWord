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
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫描二维码'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          // 防止重复处理
          if (_isProcessing) return;

          final List<Barcode> barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            if (barcode.rawValue != null && !_isProcessing) {
              print('=== 扫描到二维码 ===');
              print('原始内容: ${barcode.rawValue}');

              // 立即标记为正在处理，防止重复触发
              _isProcessing = true;

              try {
                final data = json.decode(barcode.rawValue!) as Map<String, dynamic>;
                print('解析后: $data');

                if (data['type'] == 'airword-session' && data['sessionId'] != null) {
                  final sessionId = data['sessionId'] as String;
                  print('✅ Session ID: $sessionId');

                  // 停止扫描
                  controller.stop();

                  // 先关闭当前扫码页面
                  if (mounted) {
                    Navigator.pop(context);
                  }

                  // 延迟一下，等页面关闭完成后再打开新页面
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      widget.onScanned(sessionId);
                    }
                  });
                  return;
                } else {
                  print('❌ 类型不匹配或sessionId为空');
                  print('期望: type="airword-session", 实际: type="${data['type']}"');
                  print('这不是AirWord的二维码，请扫描正确的二维码');

                  // 重置处理状态，允许继续扫描
                  _isProcessing = false;
                }
              } catch (e) {
                print('❌ 解析失败: $e');
                print('原始内容: ${barcode.rawValue}');
                print('这不是有效的JSON格式');

                // 重置处理状态，允许继续扫描
                _isProcessing = false;
              }
            }
          }
        },
      ),
    );
  }
}
