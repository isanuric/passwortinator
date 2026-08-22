import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/action_buttons.dart';
import 'widgets/length_slider.dart';
import 'widgets/options_card.dart';
import 'widgets/password_display_card.dart';

/// Main screen of the Password Generator application.
///
/// This screen is intentionally thin: every child card is a `ConsumerWidget`
/// that watches only the state it needs via `select`. A slider tick therefore
/// only rebuilds the slider and the strength display instead of the whole
/// widget hierarchy (options and action buttons stay untouched).
class PasswordGeneratorScreen extends ConsumerWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_rounded, size: 24),
            SizedBox(width: 8),
            Text('Passwordinator'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Password Display with strength indicator & copy
                  PasswordDisplayCard(),
                  SizedBox(height: 16),

                  // 2. Password Length Slider
                  LengthSlider(),
                  SizedBox(height: 16),

                  // 3. Character Options (Uppercase, Lowercase, Numbers, Symbols)
                  OptionsCard(),
                  SizedBox(height: 24),

                  // 4. Action Buttons (Regenerate & Copy)
                  ActionButtons(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
