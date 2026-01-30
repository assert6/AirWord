import 'package:flutter/material.dart';
import 'package:airword_app/config/app_config.dart';
import 'qr_scan_screen.dart';
import 'input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AirWord'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // 环境指示器（只读）
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppConfig.isDev ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              AppConfig.environmentName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.keyboard,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              // 标题
              const Text(
                'AirWord',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // 描述
              const Text(
                '实时输入同步工具',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // 服务器地址显示
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppConfig.wsUrl,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 扫码按钮
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRScanScreen(
                          onScanned: (sessionId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InputScreen(sessionId: sessionId),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 28),
                  label: const Text(
                    '扫描二维码',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 手动输入Session ID按钮（调试用）
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showSessionInputDialog(context);
                  },
                  icon: const Icon(Icons.edit, size: 28),
                  label: const Text(
                    '手动输入Session ID (调试)',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 使用说明
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '使用说明:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. 在Web端打开AirWord，生成二维码',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    Text(
                      '2. 点击"扫描二维码"按钮',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    Text(
                      '3. 扫描Web端的二维码建立连接',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    Text(
                      '4. 在App中输入，内容实时同步到Web端',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
