import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryDark = Color(0xFFE53935);
  static const Color secondary = Color(0xFFFFC107);
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFFF5252);
  static const Color background = Color(0xFFFFF8E7);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF2D3142);
  static const Color cartoonBorder = Color(0xFFFF8A65);

  static TextStyle get displayFont => GoogleFonts.fredoka();
  static TextStyle get bodyFont => GoogleFonts.baloo2();

  static ThemeData get lightTheme {
    final display = GoogleFonts.fredokaTextTheme();
    final body = GoogleFonts.baloo2TextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surface: surface,
        primary: primary,
        secondary: secondary,
      ),
      scaffoldBackgroundColor: background,
      textTheme: display.merge(body).copyWith(
            displayLarge: GoogleFonts.fredoka(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
            displayMedium: GoogleFonts.fredoka(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
            headlineMedium: GoogleFonts.fredoka(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
            headlineSmall: GoogleFonts.fredoka(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
            titleLarge: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
            titleMedium: GoogleFonts.baloo2(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
            bodyLarge: GoogleFonts.baloo2(
              fontSize: 16,
              color: textDark,
              height: 1.4,
            ),
            bodyMedium: GoogleFonts.baloo2(
              fontSize: 14,
              color: textDark,
              height: 1.35,
            ),
            labelLarge: GoogleFonts.baloo2(
              fontWeight: FontWeight.w700,
            ),
          ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textDark,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 58),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 3,
          shadowColor: primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: primaryDark, width: 2),
          ),
          textStyle: GoogleFonts.baloo2(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: cartoonBorder.withValues(alpha: 0.2), width: 2),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearMinHeight: 12,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      chipTheme: ChipThemeData(
        labelStyle: GoogleFonts.baloo2(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cartoonBorder, width: 1.5),
        ),
      ),
    );
  }
}

class ZonePalette {
  const ZonePalette({
    required this.primary,
    required this.accent,
    required this.background,
  });

  final Color primary;
  final Color accent;
  final Color background;

  static const jungleGrove = ZonePalette(
    primary: Color(0xFF43A047),
    accent: Color(0xFFFF9800),
    background: Color(0xFFE8F5E9),
  );

  static const numberMountain = ZonePalette(
    primary: Color(0xFF5C6BC0),
    accent: Color(0xFFFF7043),
    background: Color(0xFFE8EAF6),
  );

  static const letterLane = ZonePalette(
    primary: Color(0xFFAB47BC),
    accent: Color(0xFF26C6DA),
    background: Color(0xFFF3E5F5),
  );

  static const colorCanyon = ZonePalette(
    primary: Color(0xFFEC407A),
    accent: Color(0xFFFFCA28),
    background: Color(0xFFFCE4EC),
  );

  static const dinosaurs = ZonePalette(
    primary: Color(0xFF795548),
    accent: Color(0xFFFF8F00),
    background: Color(0xFFEFEBE9),
  );

  static const space = ZonePalette(
    primary: Color(0xFF3949AB),
    accent: Color(0xFF7E57C2),
    background: Color(0xFFE8EAF6),
  );

  static const drawingDen = ZonePalette(
    primary: Color(0xFF42A5F5),
    accent: Color(0xFFFF7043),
    background: Color(0xFFE3F2FD),
  );

  static ZonePalette forZone(String zoneId) {
    switch (zoneId) {
      case 'jungle_grove':
        return jungleGrove;
      case 'number_mountain':
        return numberMountain;
      case 'letter_lane':
        return letterLane;
      case 'color_canyon':
        return colorCanyon;
      case 'dinosaurs':
        return dinosaurs;
      case 'space_science':
        return space;
      case 'drawing_den':
        return drawingDen;
      default:
        return jungleGrove;
    }
  }
}

/// Kid-friendly 24-color palette for Drawing Den.
class KidColorPalette {
  KidColorPalette._();

  static const List<Color> colors = [
    Color(0xFFFF5252),
    Color(0xFFFF4081),
    Color(0xFFE040FB),
    Color(0xFF7C4DFF),
    Color(0xFF536DFE),
    Color(0xFF448AFF),
    Color(0xFF40C4FF),
    Color(0xFF18FFFF),
    Color(0xFF64FFDA),
    Color(0xFF69F0AE),
    Color(0xFFB2FF59),
    Color(0xFFEEFF41),
    Color(0xFFFFFF00),
    Color(0xFFFFD740),
    Color(0xFFFFAB40),
    Color(0xFFFF6E40),
    Color(0xFF8D6E63),
    Color(0xFFBDBDBD),
    Color(0xFF212121),
    Color(0xFFFFFFFF),
    Color(0xFFFF8A80),
    Color(0xFF80D8FF),
    Color(0xFFA7FFEB),
    Color(0xFFFFCC80),
  ];
}
