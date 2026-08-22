import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// Card widget containing the password length slider control.
class LengthSlider extends StatelessWidget {
  const LengthSlider({
    super.key,
    required this.length,
    required this.onLengthChanged,
  });

  final int length;
  final ValueChanged<int> onLengthChanged;

  @override
  Widget build(BuildContext context) {
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
                      'Passwortlänge',
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
                    '$length Zeichen',
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
              onChanged: (value) => onLengthChanged(value.round()),
            ),

            // Min and Max range hints
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppConstants.minPasswordLength} Zeichen',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${AppConstants.maxPasswordLength} Zeichen',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
