import 'package:flutter/material.dart';
import 'package:expense_tracker/app/app.dart';
import 'package:expense_tracker/app/di/injection_container.dart' as di;
import 'package:expense_tracker/core/constants/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig(
    environment: AppEnvironment.dev,
    appTitle: 'Expense Tracker [DEV]',
    databaseName: 'expense_tracker_dev',
  );

  await di.init(config);

  runApp(const MyApp());
}
