import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passwortinator/src/app.dart';
import 'package:passwortinator/src/features/password_generator/ui/password_generator_screen.dart';
import 'package:passwortinator/src/features/password_generator/ui/widgets/action_buttons.dart';
import 'package:passwortinator/src/features/password_generator/ui/widgets/length_slider.dart';
import 'package:passwortinator/src/features/password_generator/ui/widgets/options_card.dart';
import 'package:passwortinator/src/features/password_generator/ui/widgets/password_display_card.dart';

void main() {
  Widget buildApp() => const ProviderScope(child: PasswordGeneratorApp());

  /// Finds the length pill text, e.g. '16 characters' (not 'Special characters').
  Finder characterCountFinder() => find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            RegExp(r'^\d+ characters$').hasMatch(widget.data!),
      );

  /// Scrolls [finder] into view (if needed) and taps it.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('PasswordGeneratorScreen', () {
    testWidgets('renders all main sections', (tester) async {
      await tester.pumpWidget(buildApp());

      expect(find.text('Passwortinator'), findsOneWidget);
      expect(find.text('Generated password'), findsOneWidget);
      expect(find.text('Password length'), findsOneWidget);
      expect(find.text('Character options'), findsOneWidget);
      expect(find.text('Regenerate'), findsOneWidget);
      expect(find.text('Copy password'), findsOneWidget);
      expect(characterCountFinder(), findsOneWidget);
      expect(find.textContaining('Bit Entropie'), findsOneWidget);
    });

    testWidgets('regenerate button creates a new password', (tester) async {
      await tester.pumpWidget(buildApp());

      String displayedPassword() =>
          tester.widget<SelectableText>(find.byType(SelectableText)).data!;

      final initial = displayedPassword();

      await tapVisible(tester, find.widgetWithText(FilledButton, 'Regenerate'));

      expect(displayedPassword(), isNot(equals(initial)));
      expect(displayedPassword().length, equals(initial.length));
    });

    testWidgets('copy button copies to clipboard and shows snack bar',
        (tester) async {
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          calls.add(call);
          return null;
        },
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        );
      });

      await tester.pumpWidget(buildApp());

      await tapVisible(
        tester,
        find.widgetWithText(OutlinedButton, 'Copy password'),
      );
      await tester.pump();

      expect(find.text('Password copied!'), findsOneWidget);
      expect(
        calls.any((c) => c.method == 'Clipboard.setData'),
        isTrue,
      );
    });

    testWidgets('dragging the length slider updates the character count',
        (tester) async {
      await tester.pumpWidget(buildApp());

      String countLabel() =>
          tester.widget<Text>(characterCountFinder()).data!;

      expect(countLabel(), contains('16'));

      await tester.ensureVisible(find.byType(Slider));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Slider), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(countLabel(), isNot(contains('16')));
    });

    testWidgets('slider clamps to min and max allowed lengths',
        (tester) async {
      await tester.pumpWidget(buildApp());

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, equals(8));
      expect(slider.max, equals(64));
      expect(slider.divisions, equals(56));
    });

    testWidgets('last active category cannot be disabled', (tester) async {
      await tester.pumpWidget(buildApp());

      expect(find.byType(SwitchListTile), findsNWidgets(4));

      // Disable the last three categories one by one
      for (var i = 1; i < 4; i++) {
        await tester.ensureVisible(find.byType(SwitchListTile).at(i));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(SwitchListTile).at(i));
        await tester.pumpAndSettle();
      }

      // The only remaining (first) switch must be disabled
      final firstTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile).at(0),
      );
      expect(firstTile.value, isTrue);
      expect(firstTile.onChanged, isNull);
    });

    testWidgets('strength indicator exposes semantics label', (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(buildApp());

      // Default config (all categories, length 16) -> Strong.
      // The container node merges descendants' labels, so match via RegExp.
      expect(
        find.bySemanticsLabel(RegExp(r'Password strength: Strong')),
        findsOneWidget,
      );

      semanticsHandle.dispose();
    });

    testWidgets('strength label changes to Weak when only lowercase and short',
        (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(buildApp());

      // Disable uppercase, numbers and special characters -> only lowercase
      await tester.ensureVisible(find.byType(SwitchListTile).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile).at(0));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile).at(2));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile).at(3));
      await tester.pumpAndSettle();

      // Drag slider far left -> length 8 (weak)
      await tester.ensureVisible(find.byType(Slider));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Slider), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(RegExp('Password strength: Weak')),
        findsOneWidget,
      );

      semanticsHandle.dispose();
    });

    testWidgets('screen is a thin wrapper around select-based child widgets',
        (tester) async {
      await tester.pumpWidget(buildApp());

      expect(find.byType(PasswordGeneratorScreen), findsOneWidget);
      expect(find.byType(PasswordDisplayCard), findsOneWidget);
      expect(find.byType(LengthSlider), findsOneWidget);
      expect(find.byType(OptionsCard), findsOneWidget);
      expect(find.byType(ActionButtons), findsOneWidget);
    });
  });
}