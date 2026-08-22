import 'package:flutter/material.dart';

/// Central, premium design system for the app (Material 3).
///
/// Provides a refined color scheme, soft glass surfaces and brand gradients.
/// The app always renders in the dark brand theme (see [PasswordGeneratorApp]),
/// so this only builds a dark [ThemeData].
class AppTheme {
  AppTheme._();

  /// Brand gradient used for primary actions and highlights.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B4BE6), Color(0xFF9B6CFF)],
  );

  /// Secondary gradient for interactive accents.
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2FB3FF), Color(0xFF5B4BE6)],
  );

  static ThemeData get darkTheme => _build();

  static ThemeData _build() {
    const brightness = Brightness.dark;
    final scheme = _colorScheme();
    final baseText = ThemeData(brightness: brightness).textTheme;
    final textTheme = baseText.copyWith(
      headlineSmall: baseText.headlineSmall
          ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleMedium: baseText.titleMedium
          ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.2),
      titleSmall: baseText.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: baseText.bodyMedium?.copyWith(height: 1.45),
      labelLarge: baseText.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelMedium: baseText.labelMedium?.copyWith(letterSpacing: 0.1),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: scheme.surfaceContainerLowest,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: scheme.surfaceContainerHigh.withValues(
            alpha: 0.6,
          ),
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primaryContainer.withValues(alpha: 0.45),
        thumbColor: Colors.white,
        disabledThumbColor: Colors.white,
        overlayColor: scheme.primary.withValues(alpha: 0.16),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        thumbShape: _BorderedSliderThumbShape(
          enabledThumbRadius: 10,
          elevation: 3,
          pressedElevation: 6,
          borderColor: scheme.primary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A213A),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ColorScheme _colorScheme() {
    return const ColorScheme.dark(
      primary: Color(0xFF8B7DFF),
      onPrimary: Color(0xFF17103A),
      primaryContainer: Color(0xFF2E2450),
      onPrimaryContainer: Color(0xFFE3DEFF),
      secondary: Color(0xFF4FD1FF),
      onSecondary: Color(0xFF00344A),
      secondaryContainer: Color(0xFF103A52),
      onSecondaryContainer: Color(0xFFC6EEFF),
      tertiary: Color(0xFFFF8AC2),
      onTertiary: Color(0xFF54262F),
      error: Color(0xFFFF6B81),
      onError: Color(0xFF49040F),
      surface: Color(0xFF070B16),
      onSurface: Color(0xFFE9EDFB),
      surfaceContainerLowest: Color(0xFF131A2E),
      surfaceContainerLow: Color(0xFF111628),
      surfaceContainerHigh: Color(0xFF1C2440),
      surfaceContainerHighest: Color(0xFF1D2440),
      onSurfaceVariant: Color(0xFF9AA4C4),
      outline: Color(0xFF3A4263),
      outlineVariant: Color(0xFF252C47),
      shadow: Color(0xFF000000),
    );
  }
}

/// Slider thumb with a high-contrast white fill and a colored ring.
///
/// The standard Material thumb can blend into the card background (light mode)
/// or into the track (dark mode). This shape keeps a white core and paints a
/// brand-colored ring on top so the thumb stays clearly visible on any
/// background, at any slider position.
class _BorderedSliderThumbShape extends RoundSliderThumbShape {
  const _BorderedSliderThumbShape({
    super.enabledThumbRadius = 10,
    super.elevation = 3,
    super.pressedElevation = 6,
    required this.borderColor,
  });

  static const double _borderWidth = 2.0;

  final Color borderColor;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );

    final canvas = context.canvas;
    canvas.drawCircle(
      center,
      enabledThumbRadius - _borderWidth / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth
        ..color = borderColor,
    );
  }
}
