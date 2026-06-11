import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// ---------------------------------------------------------------------------
// Theme mode provider
// ---------------------------------------------------------------------------

/// Provider for the current theme mode. Defaults to [ThemeMode.system].
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// ---------------------------------------------------------------------------
// MargineTheme
// ---------------------------------------------------------------------------

/// Margine Material 3 theme definition.
///
/// Light mode: "Warm Court" — warm ivory surfaces, deep forest tennis green.
/// Dark mode: "Night Match" — off-black surfaces, neon tennis green.
class MargineTheme {
  MargineTheme._();

  // ── Light mode ──────────────────────────────────────────────────────────

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF557000),
      brightness: Brightness.light,
      surface: const Color(0xFFF5F0EB),
      onSurface: const Color(0xFF1C1C1E),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF5F0EB),

      // ── Card ──────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFFFCFAF7),
        surfaceTintColor: Colors.transparent,
      ),

      // ── Elevated button ───────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF557000),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFCFAF7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFD4CFCA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFD4CFCA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF557000), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ── Bottom navigation bar ─────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFFF5F0EB),
        selectedItemColor: const Color(0xFF557000),
        unselectedItemColor: const Color(0xFF5A5A5E),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── App bar ───────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F0EB),
        foregroundColor: Color(0xFF1C1C1E),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
        ),
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: const Color(0xFFEEF9D0),
        side: BorderSide.none,
      ),

      // ── Text theme (Inter is the system default on Android) ───────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(fontFamily: 'Inter', fontSize: 30, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ── Dark mode ───────────────────────────────────────────────────────────

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFC5F02E),
      brightness: Brightness.dark,
      surface: const Color(0xFF1C1C1E),
      onSurface: const Color(0xFFF5F0EB),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF1C1C1E),

      // ── Card ──────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF262626),
        surfaceTintColor: Colors.transparent,
      ),

      // ── Elevated button ───────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC5F02E),
          foregroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF262626),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF3A3A3E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF3A3A3E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC5F02E), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ── Bottom navigation bar ─────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: const Color(0xFFC5F02E),
        unselectedItemColor: const Color(0xFF606060),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── App bar ───────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1C1E),
        foregroundColor: Color(0xFFF5F0EB),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF5F0EB),
        ),
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: const Color(0xFF2A3A00),
        side: BorderSide.none,
      ),

      // ── Text theme ────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(fontFamily: 'Inter', fontSize: 30, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
