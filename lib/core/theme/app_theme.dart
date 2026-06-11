import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Theme mode provider
// ---------------------------------------------------------------------------

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// ---------------------------------------------------------------------------
// MargineTheme — "Safran & Ardoise" (complete rebrand)
// ---------------------------------------------------------------------------

/// Margine v2.0 Material 3 theme — "Safran & Ardoise".
///
/// A warm, bold palette:
///   Dark  — charcoal backgrounds, saffron gold primary, slate blue secondary
///   Light — warm ivory background, dark gold primary, muted slate
///
/// Typography:
///   - Sora (Google Fonts) — display / headings (Medium–ExtraBold)
///   - Inter (Google Fonts) — body / UI / labels (Regular–SemiBold)
class MargineTheme {
  MargineTheme._();

  // ── Common tokens ────────────────────────────────────────────────────────

  static const _cardRadius = 20.0;
  static const _buttonRadius = 14.0;
  static const _inputRadius = 12.0;
  static const _chipRadius = 12.0;
  static const _sheetRadius = 24.0;

  // ── Light palette ────────────────────────────────────────────────────────

  static const _lightBg = Color(0xFFF5F0EB);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightPrimary = Color(0xFFB8860B);   // dark gold
  static const _lightOnPrimary = Color(0xFFFFFFFF);
  static const _lightSecondary = Color(0xFF4A5687);  // muted slate
  static const _lightText = Color(0xFF1A1A22);
  static const _lightTextMuted = Color(0xFF7A7A88);
  static const _lightOutline = Color(0xFFD6D0C8);
  static const _lightError = Color(0xFFC73E1D);

  // ── Dark palette ─────────────────────────────────────────────────────────

  static const _darkBg = Color(0xFF0D0D12);
  static const _darkSurface = Color(0xFF16161C);
  static const _darkCard = Color(0xFF1E1E28);
  static const _darkPrimary = Color(0xFFD4A74D);    // saffron gold
  static const _darkOnPrimary = Color(0xFF0D0D12);
  static const _darkSecondary = Color(0xFF7A8FAF);  // slate blue
  static const _darkText = Color(0xFFF0EDE8);
  static const _darkTextMuted = Color(0xFF8A8A98);
  static const _darkOutline = Color(0xFF2A2A35);
  static const _darkError = Color(0xFFD94A3D);

  // ── Shared semantic colours ──────────────────────────────────────────────

  static const Color profitGreen = Color(0xFF3A8A6C);
  static const Color lossRed = Color(0xFFD94A3D);
  static const Color statusBought = Color(0xFF3A8A6C);
  static const Color statusListed = Color(0xFF5B7FBF);
  static const Color statusSold = Color(0xFFD4A74D);

  // ── Light ThemeData ──────────────────────────────────────────────────────

  static ThemeData get light {
    final cs = ColorScheme.light(
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      primaryContainer: _lightPrimary.withValues(alpha: 0.12),
      onPrimaryContainer: _lightPrimary,
      secondary: _lightSecondary,
      onSecondary: Colors.white,
      surface: _lightBg,
      onSurface: _lightText,
      surfaceContainerHighest: _lightSurface,
      onSurfaceVariant: _lightTextMuted,
      error: _lightError,
      onError: Colors.white,
      outline: _lightOutline,
      outlineVariant: _lightOutline.withValues(alpha: 0.4),
      surfaceTint: Colors.transparent,
    );

    return _buildTheme(cs, _lightBg, _lightSurface, _lightText, _lightTextMuted);
  }

  // ── Dark ThemeData ───────────────────────────────────────────────────────

  static ThemeData get dark {
    final cs = ColorScheme.dark(
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      primaryContainer: _darkPrimary.withValues(alpha: 0.15),
      onPrimaryContainer: _darkPrimary,
      secondary: _darkSecondary,
      onSecondary: _darkBg,
      surface: _darkBg,
      onSurface: _darkText,
      surfaceContainerHighest: _darkCard,
      onSurfaceVariant: _darkTextMuted,
      error: _darkError,
      onError: _darkBg,
      outline: _darkOutline,
      outlineVariant: _darkOutline.withValues(alpha: 0.4),
      surfaceTint: Colors.transparent,
    );

    return _buildTheme(cs, _darkBg, _darkCard, _darkText, _darkTextMuted);
  }

  // ── Shared theme builder ─────────────────────────────────────────────────

  static ThemeData _buildTheme(
    ColorScheme cs,
    Color bg,
    Color cardColor,
    Color text,
    Color textMuted,
  ) {
    final isDark = cs.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: bg,
      splashFactory: NoSplash.splashFactory,

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shadowColor: isDark ? Colors.black.withValues(alpha: 0.2) : cs.primary.withValues(alpha: 0.04),
      ),

      // ── Elevated button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.primary.withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Input decoration ──────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? _darkSurface : _lightBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: cs.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: textMuted),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: textMuted.withValues(alpha: 0.6)),
      ),

      // ── App bar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),

      // ── Bottom sheet ──────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        dragHandleColor: cs.outline,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(_sheetRadius)),
        ),
        backgroundColor: cardColor,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_chipRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        backgroundColor: cs.primary.withValues(alpha: 0.1),
        selectedColor: cs.primary,
        side: BorderSide.none,
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: cs.outline.withValues(alpha: 0.5),
      ),

      // ── Floating action button ────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
      ),

      // ── Text theme ────────────────────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.sora(
          fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -0.02, color: text,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.01, color: text,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.01, color: text,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 22, fontWeight: FontWeight.w600, color: text,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 20, fontWeight: FontWeight.w600, color: text,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 17, fontWeight: FontWeight.w500, color: text,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: text,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15, fontWeight: FontWeight.w600, color: text,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w600, color: text,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, color: text,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, color: text,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, color: textMuted,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.02, color: text,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.02, color: textMuted,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.02, color: textMuted,
        ),
      ),
    );
  }
}
