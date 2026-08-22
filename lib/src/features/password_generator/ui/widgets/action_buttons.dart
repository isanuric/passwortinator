import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../logic/password_generator_provider.dart';
import '../clipboard_utils.dart';

/// Primary actions pinned to the bottom edge: regenerate (dominant) and copy
/// (secondary) stacked full-width, so both actions are thumb-friendly.
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
        // Secondary copy button – full width, on top
        _BottomCopyButton(password: password),
        const SizedBox(height: 10),

        // Primary regenerate button – full width, below
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.35),
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
      ],
    );
  }
}

/// Full-width copy button with self-contained feedback.
///
/// On tap it copies the password and briefly shows "Copied ✓" instead of a
/// snack bar, so it never covers the regenerate button below it.
class _BottomCopyButton extends StatefulWidget {
  const _BottomCopyButton({required this.password});

  final String password;

  @override
  State<_BottomCopyButton> createState() => _BottomCopyButtonState();
}

class _BottomCopyButtonState extends State<_BottomCopyButton> {
  bool _copied = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    await ClipboardUtils.copy(widget.password);
    if (!mounted) return;
    setState(() => _copied = true);
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: _handleCopy,
      style: OutlinedButton.styleFrom(
        foregroundColor: _copied ? cs.primary : cs.primary,
        backgroundColor: _copied
            ? cs.primaryContainer.withValues(alpha: 0.5)
            : cs.surfaceContainerLowest.withValues(alpha: 0.6),
        side: BorderSide(
          color: _copied
              ? cs.primary.withValues(alpha: 0.7)
              : cs.outlineVariant.withValues(alpha: 0.8),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      icon: Icon(
        _copied ? Icons.check_rounded : Icons.copy_rounded,
        size: 18,
      ),
      label: Text(_copied ? 'Copied' : 'Copy'),
    );
  }
}