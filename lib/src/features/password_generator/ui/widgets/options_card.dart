import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../logic/password_generator_provider.dart';
import '../../models/password_config.dart';

/// Minimal character set selector: the four main categories as compact chips
/// plus two toggle rows (Strict and exclude-similar) with a short explanation
/// each, so the user understands what the options do.
///
/// Watches only the configuration – it is not rebuilt when the password or the
/// length slider changes.
class OptionsCard extends ConsumerWidget {
  const OptionsCard({super.key});

  /// The four main categories shown as chips, with their compact labels.
  static const List<(PasswordCategory, String)> _chipCategories = [
    (PasswordCategory.uppercase, 'A-Z'),
    (PasswordCategory.lowercase, 'a-z'),
    (PasswordCategory.numbers, '0-9'),
    (PasswordCategory.special, '!@#'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(
      passwordGeneratorProvider.select((s) => s.config),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main character categories as chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (category, label) in _chipCategories)
                _buildCategoryChip(
                  cs: cs,
                  config: config,
                  category: category,
                  label: label,
                  notifier: notifier,
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),

          // Extra options with explanation, each on its own row
          _buildToggleRow(
            theme: theme,
            icon: Icons.terminal_rounded,
            iconColor: config.includeSpecialStrict ? cs.secondary : null,
            // Show the actual characters instead of a name, so the user sees
            // exactly which symbols get added.
            title: AppConstants.strictSpecialCharacters,
            description: 'not allowed by some systems',
            value: config.includeSpecialStrict,
            onChanged: (v) =>
                notifier.toggleCategory(PasswordCategory.specialStrict, v),
          ),
          _buildToggleRow(
            theme: theme,
            icon: Icons.remove_red_eye_outlined,
            iconColor: config.excludeAmbiguous ? cs.secondary : null,
            title: '0O 1l',
            description: 'skip similar (0/O, 1/l/I)',
            value: config.excludeAmbiguous,
            onChanged: notifier.setExcludeAmbiguous,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required ColorScheme cs,
    required PasswordConfig config,
    required PasswordCategory category,
    required String label,
    required PasswordGeneratorNotifier notifier,
  }) {
    final isEnabled = config.isCategoryEnabled(category);
    final canToggle = config.canDisableCategory(category);

    return FilterChip(
      label: Text(label),
      selected: isEnabled,
      showCheckmark: false,
      // Disable the chip if it is the last active option and currently enabled
      onSelected: (!canToggle && isEnabled)
          ? null
          : (value) => notifier.toggleCategory(category, value),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isEnabled ? cs.primary : cs.onSurfaceVariant,
      ),
      selectedColor: cs.primaryContainer.withValues(alpha: 0.6),
      backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
      side: BorderSide(
        color: isEnabled
            ? cs.primary.withValues(alpha: 0.7)
            : cs.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }

  /// A full-width toggle row: icon, title, short explanation and a switch.
  Widget _buildToggleRow({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required void Function(bool) onChanged,
    Color? iconColor,
  }) {
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              icon,
              size: 17,
              color: iconColor ?? cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: value ? cs.onSurface : cs.onSurfaceVariant,
                    // Monospace keeps special characters clearly readable.
                    fontFamily: 'monospace',
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.85),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            activeThumbColor: cs.surfaceContainerLowest,
            activeTrackColor: cs.secondary,
            inactiveThumbColor: cs.surfaceContainerLowest,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}