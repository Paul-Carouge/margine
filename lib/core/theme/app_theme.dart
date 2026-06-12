import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forge_colors.dart';

// ---------------------------------------------------------------------------
// Theme mode provider
// ---------------------------------------------------------------------------

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// ---------------------------------------------------------------------------
// ForgeTheme — "Crimson / Teal / Graphite" (L'Établi v3.0.0 Forge)
// ---------------------------------------------------------------------------

/// L'Établi v3.0 Material 3 theme — "Forge".
///
/// Three pillars:
///   - **Crimson** (#C0392B) — primary actions, FAB, selections
///   - **Precision Teal** (#14B8A6) — profit, sold, success
///   - **Warm Graphite** (#15151C) — the workbench background
///
/// Typography:
///   - DM Serif Display (Google Fonts) — display / headings
///   - Outfit (Google Fonts) — body / UI / labels
class ForgeTheme {
  ForgeTheme._();

  // ── Border radius system ───────────────────────────────────────────────────

  static const _cardRadius = 20.0;
  static const _buttonRadius = 14.0;
  static const _inputRadius = 12.0;
  static const _chipRadius = 20.0; // pill shape
  static const _sheetRadius = 24.0;
  static const _fabRadius = 18.0;

  // ── Light ThemeData ────────────────────────────────────────────────────────

  static ThemeData get light {
    final cs = ForgeColors.lightScheme();
    return _buildTheme(
      cs,
      ForgeColors.lightBg,
      ForgeColors.lightSurface,
      ForgeColors.lightTextPrimary,
      ForgeColors.lightTextSecondary,
    );
  }

  // ── Dark ThemeData ─────────────────────────────────────────────────────────

  static ThemeData get dark {
    final cs = ForgeColors.darkScheme();
    return _buildTheme(
      cs,
      ForgeColors.bg,
      ForgeColors.surface,
      ForgeColors.textPrimary,
      ForgeColors.textSecondary,
    );
  }

  // ── Shared theme builder ───────────────────────────────────────────────────

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
        shadowColor: isDark
            ? ForgeColors.bg.withValues(alpha: 0.4)
            : cs.primary.withValues(alpha: 0.04),
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
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Input decoration ──────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? ForgeColors.surface : ForgeColors.lightBg,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.outfit(fontSize: 14, color: textMuted),
        hintStyle: GoogleFonts.outfit(
            fontSize: 14, color: textMuted.withValues(alpha: 0.6)),
      ),

      // ── App bar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.dmSerifDisplay(
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
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(_sheetRadius)),
        ),
        backgroundColor: cardColor,
      ),

      // ── Chip / Filter pill ────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_chipRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        labelStyle:
            GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
        backgroundColor: cardColor,
        selectedColor: ForgeColors.crimsonContainer,
        side: BorderSide.none,
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          borderRadius: BorderRadius.circular(_fabRadius),
        ),
        elevation: 0,
      ),

      // ── Text theme — DM Serif Display (display/headlines) + Outfit (body/labels) ─
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme)
          .copyWith(
        // Display — DM Serif Display
        displayLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          color: text,
        ),
        displayMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          color: text,
        ),
        displaySmall: GoogleFonts.dmSerifDisplay(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: text,
        ),
        // Headlines — DM Serif Display
        headlineLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        headlineMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        headlineSmall: GoogleFonts.dmSerifDisplay(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: text,
        ),
        // Titles (body hierarchy) — Outfit
        titleLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleSmall: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        // Body — Outfit
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: text,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: text,
        ),
        bodySmall: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
        // Labels — Outfit
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: text,
        ),
        labelMedium: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: textMuted,
        ),
        labelSmall: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: textMuted,
        ),
      ),
    );
  }
}
