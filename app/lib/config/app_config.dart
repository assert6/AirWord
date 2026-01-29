class AppConfig {
  // 从环境变量读取配置，构建时通过 --dart-define 指定
  // 示例: flutter build apk --dart-define=ENV=dev
  // 可选值: local, dev, prod

  static const String ENV = String.fromEnvironment('ENV', defaultValue: 'prod');

  // WebSocket服务器地址
  static const String wsUrlLocal = 'ws://localhost:3001';  // 本地开发
  static const String wsUrlDev = 'ws://airword-dev.assert6.com:3001';  // 测试服务器
  static const String wsUrlProd = 'ws://airword.assert6.com:3001';  // 正式服务器

  static String get wsUrl {
    switch (ENV) {
      case 'local':
        return wsUrlLocal;
      case 'dev':
        return wsUrlDev;
      case 'prod':
      default:
        return wsUrlProd;
    }
  }

  // API服务器地址
  static const String apiUrlLocal = 'http://localhost:3001/api';
  static const String apiUrlDev = 'http://airword-dev.assert6.com:3001/api';
  static const String apiUrlProd = 'http://airword.assert6.com:3001/api';

  static String get apiUrl {
    switch (ENV) {
      case 'local':
        return apiUrlLocal;
      case 'dev':
        return apiUrlDev;
      case 'prod':
      default:
        return apiUrlProd;
    }
  }

  // 当前环境
  static bool get isLocal => ENV == 'local';
  static bool get isDev => ENV == 'dev';
  static String get environmentName {
    switch (ENV) {
      case 'local':
        return '本地环境';
      case 'dev':
        return '测试环境';
      case 'prod':
      default:
        return '正式环境';
    }
  }
}
