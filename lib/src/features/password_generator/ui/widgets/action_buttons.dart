import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../logic/password_generator_provider.dart';
import '../clipboard_utils.dart';

/// Primary actions pinned to the bottom edge: a dominant regenerate button and
/// a secondary copy button side by side, so both actions are thumb-friendly.
class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(
      passwordGeneratorProvider.select((s) => s.password),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Primary regenerate button – dominant width
        Expanded(
          flex: 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FilledButton.icon(
              onPressed: notifier.regenerate,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              icon: const Icon(Icons.autorenew_rounded, size: 19),
              label: const Text('Regenerate'),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Secondary copy button – smaller share of the width
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () =>
                ClipboardUtils.copyWithFeedback(context, password),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.primary,
              backgroundColor:
                  cs.surfaceContainerLowest.withValues(alpha: 0.6),
              side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.8)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copy'),
          ),
        ),
      ],
    );
  }
}