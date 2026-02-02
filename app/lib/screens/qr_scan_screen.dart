import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

// 品牌颜色
class AppColors {
  static const Color primaryPurple = Color(0xFF9333EA);
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGray = Color(0xFF6B7280);
}

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 扫码器
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                if (barcode.rawValue != null && !_isProcessing) {
                  print('=== 扫描到二维码 ===');
                  print('原始内容: ${barcode.rawValue}');

                  _isProcessing = true;

                  try {
                    final data =
                        json.decode(barcode.rawValue!) as Map<String, dynamic>;
                    print('解析后: $data');

                    if (data['type'] == 'airword-session' &&
                        data['sessionId'] != null) {
                      final sessionId = data['sessionId'] as String;
                      print('✅ Session ID: $sessionId');

                      controller.stop();

                      if (mounted) {
                        // 通过 pop 的 result 传递 sessionId，由 HomeScreen 的 .then() 处理导航
                        Navigator.pop(context, sessionId);
                      }
                      return;
                    } else {
                      print('❌ 类型不匹配');
                      _isProcessing = false;
                    }
                  } catch (e) {
                    print('❌ 解析失败: $e');
                    _isProcessing = false;
                  }
                }
              }
            },
          ),

          // 顶部渐变遮罩
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 顶部栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        '扫描二维码',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.flash_on, color: Colors.white),
                        onPressed: () => controller.toggleTorch(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 扫描框
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primaryPurple,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 顶部角
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(),
                        _buildCorner(),
                      ],
                    ),
                  ),

                  // 扫描线动画
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.primaryPurple,
                            AppColors.primaryPurple,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 底部角
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(),
                        _buildCorner(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 底部提示
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 20),
                        SizedBox(width: 12),
                        Text(
                          '将二维码放入框内即可自动扫描',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
