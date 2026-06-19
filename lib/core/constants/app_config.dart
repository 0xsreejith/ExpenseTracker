enum AppEnvironment { dev, staging, prod }

class AppConfig {
  final AppEnvironment environment;
  final String appTitle;
  final String databaseName;

  const AppConfig({
    required this.environment,
    required this.appTitle,
    required this.databaseName,
  });

  bool get isDevelopment => environment == AppEnvironment.dev;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.prod;
}
