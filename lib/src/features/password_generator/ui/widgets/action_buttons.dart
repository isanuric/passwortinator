import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Primary action buttons for regenerating and copying the password.
class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.password,
    required this.onRegenerate,
  });

  final String password;
  final VoidCallback onRegenerate;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Password copied!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );
  }

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
          onPressed: () => _copyToClipboard(context),
          icon: const Icon(Icons.copy_rounded, size: 20),
          label: const Text('Copy password'),
        ),
      ],
    );
  }
}
