import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/password_generator_provider.dart';
import 'widgets/action_buttons.dart';
import 'widgets/length_slider.dart';
import 'widgets/options_card.dart';
import 'widgets/password_display_card.dart';

/// Main screen of the Password Generator application.
class PasswordGeneratorScreen extends ConsumerWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passwordGeneratorProvider);
    final notifier = ref.read(passwordGeneratorProvider.notifier);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Password Display with strength indicator & copy
                  PasswordDisplayCard(
                    password: state.password,
                    strength: state.strength,
                    entropy: state.entropy,
                    onRegenerate: notifier.regenerate,
                  ),
                  const SizedBox(height: 16),

                  // 2. Password Length Slider
                  // Live: length/entropy/strength update while dragging.
                  // Password is regenerated once when the drag ends.
                  LengthSlider(
                    length: state.config.length,
                    onLengthChanged: notifier.setLength,
                    onChangeEnd: notifier.regenerate,
                  ),
                  const SizedBox(height: 16),

                  // 3. Character Options (Uppercase, Lowercase, Numbers, Symbols)
                  OptionsCard(
                    config: state.config,
                    onToggleCategory: notifier.toggleCategory,
                  ),
                  const SizedBox(height: 24),

                  // 4. Action Buttons (Regenerate & Copy)
                  ActionButtons(
                    password: state.password,
                    onRegenerate: notifier.regenerate,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
