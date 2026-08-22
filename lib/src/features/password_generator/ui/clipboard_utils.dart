import 'dart:async';
import 'package:flutter/services.dart';

/// Clipboard helper with automatic clipboard hygiene.
///
/// The UI is deliberately kept out of here – copy feedback is rendered by the
/// buttons themselves (inline checkmark), so no overlay ever blocks the
/// action buttons on small screens.
class ClipboardUtils {
  ClipboardUtils._();

  /// How long a copied password stays on the clipboard before being cleared.
  static const Duration clearAfter = Duration(seconds: 60);

  static Timer? _clearTimer;

  /// Copies [text] to the system clipboard and schedules an automatic wipe
  /// after [clearAfter]. Errors are swallowed so a platform hiccup can never
  /// break the copy flow.
  static Future<void> copy(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (_) {
      // Best-effort: keep the flow alive even if the platform fails.
    }
    _scheduleAutoClear(text);
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