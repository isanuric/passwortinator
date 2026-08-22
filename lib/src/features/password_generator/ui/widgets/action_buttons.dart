import 'package:flutter/material.dart';
import '../clipboard_utils.dart';

/// Primary action buttons for regenerating and copying the password.
class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.password,
    required this.onRegenerate,
  });

  final String password;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary regenerate button
        FilledButton.icon(
          onPressed: onRegenerate,
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
