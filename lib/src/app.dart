import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/password_generator/ui/password_generator_screen.dart';

/// Root application widget configuring themes and initial screen.
class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Always use the dark brand theme so the premium violet gradient renders
    // identically on every device, regardless of the system brightness.
    final theme = AppTheme.darkTheme;
    return MaterialApp(
      title: 'Passwortinator',
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.dark,
      home: const PasswordGeneratorScreen(),
    );
  }
}
