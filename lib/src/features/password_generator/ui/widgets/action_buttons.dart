import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../logic/password_generator_provider.dart';
import '../clipboard_utils.dart';

/// Primary action buttons for regenerating and copying the password.
///
/// Watches only the current password – it is not rebuilt while the length
/// slider is dragged (the password stays stable during a drag).
class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(
      passwordGeneratorProvider.select((s) => s.password),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary gradient regenerate button
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.35),
                blurRadius: 26,
                offset: const Offset(0, 12),
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
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            icon: const Icon(Icons.autorenew_rounded, size: 22),
            label: const Text('Regenerate'),
          ),
        ),
        const SizedBox(height: 12),

        // Secondary copy button
        OutlinedButton.icon(
          onPressed: () => ClipboardUtils.copyWithFeedback(context, password),
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.primary,
            backgroundColor: cs.surfaceContainerLowest.withValues(alpha: 0.6),
            side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.8)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.copy_rounded, size: 20),
          label: const Text('Copy password'),
        ),
      ],
    );
  }
}
