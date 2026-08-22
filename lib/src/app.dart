import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/password_generator/ui/password_generator_screen.dart';

/// Root application widget configuring themes and initial screen.
class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passwortinator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const PasswordGeneratorScreen(),
    );
  }
}
