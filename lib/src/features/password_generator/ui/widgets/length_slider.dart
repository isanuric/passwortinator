import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../logic/password_generator_provider.dart';
import '../../models/password_strength.dart';

/// Card widget containing the password length slider control.
///
/// Watches only the current length. While dragging, [PasswordGeneratorNotifier.setLength]
/// updates length/entropy/strength live; the expensive password generation is
/// deferred to [PasswordGeneratorNotifier.regenerate], fired on drag end.
class LengthSlider extends ConsumerWidget {
  const LengthSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = ref.watch(
      passwordGeneratorProvider.select((s) => s.config.length),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title and length value pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.straighten_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Password length',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$length characters',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Material 3 Slider
            Slider(
              value: length.toDouble(),
              min: AppConstants.minPasswordLength.toDouble(),
              max: AppConstants.maxPasswordLength.toDouble(),
              divisions: AppConstants.maxPasswordLength - AppConstants.minPasswordLength,
              label: length.toString(),
              onChanged: (value) => notifier.setLength(value.round()),
              onChangeEnd: (_) => notifier.regenerate(),
            ),

            // Min and Max strength hints (weak -> strong)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PasswordStrength.weak.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: PasswordStrength.weak.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    PasswordStrength.strong.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: PasswordStrength.strong.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}