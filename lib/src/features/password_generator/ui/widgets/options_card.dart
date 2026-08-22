import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../logic/password_generator_provider.dart';
import '../../models/password_config.dart';

/// Minimal character set selector: a wrap of compact chips. No title, no
/// subtitle – the chips are self-explanatory (A-Z, a-z, 0-9, symbols, strict).
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

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildChip(
            context: context,
            config: config,
            category: PasswordCategory.uppercase,
            label: 'A-Z',
            notifier: notifier,
          ),
          _buildChip(
            context: context,
            config: config,
            category: PasswordCategory.lowercase,
            label: 'a-z',
            notifier: notifier,
          ),
          _buildChip(
            context: context,
            config: config,
            category: PasswordCategory.numbers,
            label: '0-9',
            notifier: notifier,
          ),
          _buildChip(
            context: context,
            config: config,
            category: PasswordCategory.special,
            label: '!@#',
            notifier: notifier,
          ),
          _buildChip(
            context: context,
            config: config,
            category: PasswordCategory.specialStrict,
            label: 'Strict',
            notifier: notifier,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required PasswordConfig config,
    required PasswordCategory category,
    required String label,
    required PasswordGeneratorNotifier notifier,
  }) {
    final cs = Theme.of(context).colorScheme;
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
}