import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary regenerate button
        FilledButton.icon(
          onPressed: notifier.regenerate,
          icon: const Icon(Icons.autorenew_rounded, size: 22),
          label: const Text('Regenerate'),
        ),
        const SizedBox(height: 12),

        // Secondary copy button
        OutlinedButton.icon(
          onPressed: () => ClipboardUtils.copyWithFeedback(context, password),
          icon: const Icon(Icons.copy_rounded, size: 20),
          label: const Text('Copy password'),
        ),
      ],
    );
  }
}