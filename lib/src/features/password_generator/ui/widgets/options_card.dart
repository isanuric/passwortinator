import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../logic/password_generator_provider.dart';
import '../../models/password_config.dart';

/// Premium card allowing users to configure which character sets to include.
///
/// Watches only the configuration – it is not rebuilt when the password or the
/// length slider changes.
class OptionsCard extends ConsumerWidget {
  const OptionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(
      passwordGeneratorProvider.select((s) => s.config),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: cs.secondary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Character options',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'At least one category must remain active.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
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
          const Divider(height: 1),
          _buildOptionRow(
            context: context,
            config: config,
            category: PasswordCategory.specialStrict,
            icon: Icons.terminal_rounded,
            onToggleCategory: notifier.toggleCategory,
          ),
        ],
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
    final cs = theme.colorScheme;
    final isEnabled = config.isCategoryEnabled(category);
    final canToggle = config.canDisableCategory(category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        secondary: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? AppTheme.primaryGradient
                : LinearGradient(
                    colors: [
                      cs.surfaceContainerHighest.withValues(alpha: 0.8),
                      cs.surfaceContainerHighest.withValues(alpha: 0.4),
                    ],
                  ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isEnabled
                ? Colors.white
                : cs.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
        title: Text(
          category.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: !canToggle && isEnabled
                ? cs.onSurface
                : (isEnabled ? cs.onSurface : cs.onSurfaceVariant),
          ),
        ),
        subtitle: Text(
          '${category.subtitle} · ${category.example}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant.withValues(alpha: 0.85),
          ),
        ),
        activeThumbColor: cs.surfaceContainerLowest,
        activeTrackColor: cs.primary,
        inactiveThumbColor: cs.surfaceContainerLowest,
        value: isEnabled,
        // Disable switch if it is the last active option and currently enabled
        onChanged: (!canToggle && isEnabled)
            ? null
            : (value) => onToggleCategory(category, value),
      ),
    );
  }
}
