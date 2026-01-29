import 'package:flutter/foundation.dart';

class AppConfig {
  // 根据 build mode 自动选择环境
  // debug 模式 -> dev 环境（连接测试服务器）
  // release 模式 -> prod 环境（连接正式服务器）

  static bool get isDev => !kReleaseMode; // debug模式
  static bool get isProd => kReleaseMode; // release模式

  // WebSocket服务器地址
  static const String wsUrlDev = 'ws://airword-dev.assert6.com:3001';  // 测试服务器
  static const String wsUrlProd = 'ws://airword.assert6.com:3001';  // 正式服务器

  static String get wsUrl => isDev ? wsUrlDev : wsUrlProd;

  // API服务器地址
  static const String apiUrlDev = 'http://airword-dev.assert6.com:3001/api';
  static const String apiUrlProd = 'http://airword.assert6.com:3001/api';

  static String get apiUrl => isDev ? apiUrlDev : apiUrlProd;

  // 当前环境名称
  static String get environmentName => isDev ? '测试环境' : '正式环境';

  // 当前环境代码
  static String get env => isDev ? 'dev' : 'prod';
}
