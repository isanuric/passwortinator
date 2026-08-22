import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_background.dart';
import 'widgets/action_buttons.dart';
import 'widgets/length_slider.dart';
import 'widgets/options_card.dart';
import 'widgets/password_display_card.dart';

/// Main screen of the Password Generator application.
///
/// Thin scaffold that paints the ambient gradient and lays out the premium
/// content cards. Each card is a `ConsumerWidget` watching only the state it
/// needs via `select`, so slider ticks rebuild only the relevant pieces.
class PasswordGeneratorScreen extends ConsumerWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(
            bounds,
          ),
          child: const Text(
            'Passwortinator',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: GradientBackground()),
          SafeArea(
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
                      // 1. Password Display with strength indicator & actions
                      PasswordDisplayCard(),
                      SizedBox(height: 18),

                      // 2. Password Length Slider
                      LengthSlider(),
                      SizedBox(height: 18),

                      // 3. Character Options
                      OptionsCard(),
                      SizedBox(height: 24),

                      // 4. Action Buttons
                      ActionButtons(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
