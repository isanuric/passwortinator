import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../logic/password_generator_provider.dart';

/// Minimal length control: a full-width slider with the current value as a
/// compact pill on the right. No title, no icons, no min/max labels.
///
/// Watches only the current length. While dragging, the notifier updates
/// length/entropy/strength live; the expensive password generation is deferred
/// to [PasswordGeneratorNotifier.regenerate] fired on drag end.
class LengthSlider extends ConsumerWidget {
  const LengthSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = ref.watch(
      passwordGeneratorProvider.select((s) => s.config.length),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: length.toDouble(),
              min: AppConstants.minPasswordLength.toDouble(),
              max: AppConstants.maxPasswordLength.toDouble(),
              divisions:
                  AppConstants.maxPasswordLength - AppConstants.minPasswordLength,
              label: length.toString(),
              onChanged: (value) => notifier.setLength(value.round()),
              onChangeEnd: (_) => notifier.regenerate(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary,
                  cs.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$length',
              style: theme.textTheme.labelLarge?.copyWith(
                color: cs.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}