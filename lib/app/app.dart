import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/app/di/injection_container.dart';
import 'package:expense_tracker/app/routes/app_router.dart';
import 'package:expense_tracker/core/constants/app_config.dart';
import 'package:expense_tracker/core/themes/app_theme.dart';
import 'package:expense_tracker/features/expenses/presentation/controllers/expense_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();

    return ChangeNotifierProvider(
      create: (context) => sl<ExpenseController>(),
      child: MaterialApp.router(
        title: config.appTitle,
        debugShowCheckedModeBanner: config.environment == AppEnvironment.dev,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
