import 'package:flutter/material.dart';

/// Central, premium design system for the app (Material 3).
///
/// Provides a refined color scheme, soft glass surfaces, brand gradients and
/// consistent component themes for light and dark mode.
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

  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = _colorScheme(isDark);
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
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: const TextStyle(
          fontSize: 21,
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
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: scheme.surfaceContainerHigh.withValues(
            alpha: isDark ? 0.6 : 0.85,
          ),
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primaryContainer.withValues(alpha: 0.45),
        thumbColor: Colors.white,
        disabledThumbColor: Colors.white,
        overlayColor: scheme.primary.withValues(alpha: 0.16),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        thumbShape: _BorderedSliderThumbShape(
          enabledThumbRadius: 12,
          elevation: 4,
          pressedElevation: 8,
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

  static ColorScheme _colorScheme(bool isDark) {
    if (isDark) {
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
    return const ColorScheme.light(
      primary: Color(0xFF5A4BE6),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE1DEFF),
      onPrimaryContainer: Color(0xFF19104A),
      secondary: Color(0xFF0086C3),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFD5ECFF),
      onSecondaryContainer: Color(0xFF00283D),
      tertiary: Color(0xFFB34E86),
      onTertiary: Color(0xFFFFFFFF),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFF4F6FC),
      onSurface: Color(0xFF141829),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFEFF1FA),
      surfaceContainerHigh: Color(0xFFE5E8F5),
      surfaceContainerHighest: Color(0xFFE5E8F5),
      onSurfaceVariant: Color(0xFF4E5575),
      outline: Color(0xFFB9C0DD),
      outlineVariant: Color(0xFFD8DCF0),
      shadow: Color(0xFF0C0D1A),
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
    super.enabledThumbRadius = 12,
    super.elevation = 4,
    super.pressedElevation = 8,
    required this.borderColor,
  });

  static const double _borderWidth = 2.5;

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
