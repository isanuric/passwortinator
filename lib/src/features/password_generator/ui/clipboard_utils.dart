import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared clipboard helper providing copy actions with user feedback and
/// automatic clipboard hygiene.
class ClipboardUtils {
  ClipboardUtils._();

  /// How long a copied password stays on the clipboard before being cleared.
  static const Duration clearAfter = Duration(seconds: 60);

  static Timer? _clearTimer;

  /// Copies [text] to the system clipboard, shows a confirmation snack bar
  /// and schedules an automatic wipe after [clearAfter].
  ///
  /// As a safeguard, the wipe only replaces the clipboard if it still holds
  /// the password we copied – anything the user copied in the meantime is
  /// left untouched.
  static void copyWithFeedback(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    _scheduleAutoClear(text);

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

  /// Cancels any pending auto-clear (used when a new copy replaces the old).
  static void _scheduleAutoClear(String copiedText) {
    _clearTimer?.cancel();
    _clearTimer = Timer(clearAfter, () async {
      // Only wipe if the clipboard still contains exactly what we copied.
      // Reading the platform clipboard is not possible on every platform,
      // so a null/error result simply means "leave it alone".
      try {
        final ClipboardData? current = await Clipboard.getData('text/plain');
        if (current?.text == copiedText) {
          await Clipboard.setData(
            const ClipboardData(text: ''),
          );
        }
      } catch (_) {
        // Ignore – clipboard clearing is best-effort.
      }
    });
  }
}