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
/// Thin scaffold that paints the ambient gradient and lays out the content
/// so it fills the whole viewport: the password and controls form a compact
/// cluster at the top, and the primary action is pinned to the bottom edge.
/// On very short screens the column scrolls instead of overflowing.
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
              fontSize: 19,
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
                child: LayoutBuilder(
                  builder: (context, viewportConstraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 10.0,
                      ),
                      // Force the column to at least fill the viewport height
                      // (minus the scroll padding), so the Spacer below pushes
                      // the action button to the bottom edge.
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight - 20,
                        ),
                        child: const IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 1. Output – password with inline copy & strength
                              PasswordDisplayCard(),
                              SizedBox(height: 10),

                              // 2. Controls – length slider + character chips
                              LengthSlider(),
                              SizedBox(height: 10),
                              OptionsCard(),

                              // Flexible gap: absorbs all leftover space so the
                              // action button sits flush at the bottom edge.
                              Spacer(),
                              SizedBox(height: 10),

                              // 3. Primary action – pinned to the bottom
                              ActionButtons(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
