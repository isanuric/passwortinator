import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../logic/password_generator_provider.dart';
import '../../models/password_strength.dart';

/// Premium card containing the password length slider.
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title and length value pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.straighten_rounded,
                      size: 18,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Password length',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary,
                      cs.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '$length characters',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Material 3 Slider
          Slider(
            value: length.toDouble(),
            min: AppConstants.minPasswordLength.toDouble(),
            max: AppConstants.maxPasswordLength.toDouble(),
            divisions:
                AppConstants.maxPasswordLength - AppConstants.minPasswordLength,
            label: length.toString(),
            onChanged: (value) => notifier.setLength(value.round()),
            onChangeEnd: (_) => notifier.regenerate(),
          ),
          const SizedBox(height: 2),

          // Min and max strength hints (weak -> strong)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  PasswordStrength.weak.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: PasswordStrength.weak.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  PasswordStrength.strong.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: PasswordStrength.strong.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
