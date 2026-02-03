import 'package:flutter/material.dart';
import 'package:airword_app/config/app_config.dart';
import 'qr_scan_screen.dart';
import 'input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 品牌颜色 - 与桌面端/Web端一致
  static const Color primaryPurple = Color(0xFF9333EA); // purple-600
  static const Color primaryIndigo = Color(0xFF4F46E5); // indigo-600
  static const Color greenAccent = Color(0xFF10B981); // green-500
  static const Color orangeAccent = Color(0xFFF59E0B); // amber-500

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFAF5FF), // purple-50
              Color(0xFFFDF2F8), // pink-50
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 顶部版本号显示
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConfig.isDev ? orangeAccent : greenAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'v${AppConfig.version}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Logo/Icon - 带阴影效果
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryPurple, primaryIndigo],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.keyboard,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 标题
                  const Text(
                    'AirWord',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937), // gray-800
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 描述
                  Text(
                    '实时输入同步工具',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // 扫码按钮 - 主要按钮
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryPurple, primaryIndigo],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryPurple.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final sessionId = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRScanScreen(),
                            ),
                          );
                          if (sessionId != null && context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InputScreen(sessionId: sessionId),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.qr_code_scanner,
                            size: 24, color: Colors.white),
                        label: const Text(
                          '扫描二维码',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 手动输入Session ID按钮（调试用）- 次要按钮
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showSessionInputDialog(context);
                      },
                      icon: Icon(Icons.edit, size: 24, color: Colors.grey[700]),
                      label: Text(
                        '手动输入Session ID',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 使用说明 - 卡片样式
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: primaryPurple,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '使用说明',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStep('1', '在桌面端或Web端打开AirWord'),
                        const SizedBox(height: 12),
                        _buildStep('2', '使用App扫描二维码建立连接'),
                        const SizedBox(height: 12),
                        _buildStep('3', '在App中输入，内容实时同步'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  void _showSessionInputDialog(BuildContext context) {
    final TextEditingController sessionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('输入Session ID'),
        content: TextField(
          controller: sessionController,
          decoration: const InputDecoration(
            hintText: '粘贴Session ID',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final sessionId = sessionController.text.trim();
              if (sessionId.isNotEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputScreen(sessionId: sessionId),
                  ),
                );
              }
            },
            child: const Text('连接'),
          ),
        ],
      ),
    );
  }
}
