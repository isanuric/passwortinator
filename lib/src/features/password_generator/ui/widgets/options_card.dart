import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/password_generator_provider.dart';
import '../../models/password_config.dart';

/// Card widget allowing users to configure which character sets to include.
///
/// Watches only the configuration – it is not rebuilt when the password or
/// the length slider changes.
class OptionsCard extends ConsumerWidget {
  const OptionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(
      passwordGeneratorProvider.select((s) => s.config),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Header
            Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Character options',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'At least one category must remain active.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),

            // Options Rows
            _buildOptionRow(
              context: context,
              config: config,
              category: PasswordCategory.uppercase,
              icon: Icons.text_fields_rounded,
              onToggleCategory: notifier.toggleCategory,
            ),
            const Divider(height: 1),
            _buildOptionRow(
              context: context,
              config: config,
              category: PasswordCategory.lowercase,
              icon: Icons.format_size_rounded,
              onToggleCategory: notifier.toggleCategory,
            ),
            const Divider(height: 1),
            _buildOptionRow(
              context: context,
              config: config,
              category: PasswordCategory.numbers,
              icon: Icons.pin_rounded,
              onToggleCategory: notifier.toggleCategory,
            ),
            const Divider(height: 1),
            _buildOptionRow(
              context: context,
              config: config,
              category: PasswordCategory.special,
              icon: Icons.star_border_rounded,
              onToggleCategory: notifier.toggleCategory,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required BuildContext context,
    required PasswordConfig config,
    required PasswordCategory category,
    required IconData icon,
    required void Function(PasswordCategory category, bool isEnabled)
        onToggleCategory,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = config.isCategoryEnabled(category);
    final canToggle = config.canDisableCategory(category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isEnabled
                ? colorScheme.primaryContainer.withValues(alpha: 0.7)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isEnabled
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        title: Text(
          category.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: !canToggle && isEnabled
                ? colorScheme.onSurface
                : (isEnabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant),
          ),
        ),
        subtitle: Text(
          '${category.subtitle} (${category.example})',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
        value: isEnabled,
        // Disable switch if it is the last active option and currently enabled
        onChanged: (!canToggle && isEnabled)
            ? null
            : (value) => onToggleCategory(category, value),
      ),
    );
  }
}