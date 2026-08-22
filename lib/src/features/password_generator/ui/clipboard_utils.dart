import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared clipboard helper providing copy actions with user feedback.
class ClipboardUtils {
  ClipboardUtils._();

  /// Copies [text] to the system clipboard and shows a confirmation snack bar.
  static void copyWithFeedback(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Password copied!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF1E293B),
      ),
    );
  }
}
