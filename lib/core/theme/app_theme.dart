import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Theme mode provider
// ---------------------------------------------------------------------------

/// Provider for the current theme mode. Defaults to [ThemeMode.system].
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// ---------------------------------------------------------------------------
// MargineTheme — "Noir & Amethyst"
// ---------------------------------------------------------------------------

/// Margine v2.0 Material 3 theme — "Noir & Amethyst" rebrand.
///
/// Light mode: "Pearl" — pearl surfaces, deep amethyst primary, antique gold.
/// Dark mode: "Onyx" — near-black surfaces, electric amethyst, luminous gold.
///
/// Typography:
/// - Google Fonts Sora for display/headings (Medium, Semibold, Bold, ExtraBold)
/// - Google Fonts Inter for body/UI/text (Regular, Medium, Semibold)
class MargineTheme {
  MargineTheme._();

  // ── Common theme properties ─────────────────────────────────────────────

  static const _cardRadius = 16.0;
  static const _buttonRadius = 12.0;
  static const _inputRadius = 10.0;
  static const _chipRadius = 8.0;
  static const _dialogRadius = 16.0;

  // ── Light Mode Palette ──────────────────────────────────────────────────

  static const _lightPrimary = Color(0xFF2D2B55);
  static const _lightOnPrimary = Color(0xFFFFFFFF);
  static const _lightAccent = Color(0xFFB8860B);
  static const _lightOnAccent = Color(0xFFFFFFFF);
  static const _lightSurface = Color(0xFFF5F3F0);
  static const _lightSurfaceContainer = Color(0xFFFFFFFF);
  static const _lightTextPrimary = Color(0xFF1A1A2E);
  static const _lightTextSecondary = Color(0xFF5C5C70);
  static const _lightOutline = Color(0xFFD6D5E0);
  static const _lightOutlineSubtle = Color(0xFFE8E7F0);
  static const _lightDisabled = Color(0xFFB0B0C0);
  static const _lightError = Color(0xFFC62828);
  static const _lightErrorContainer = Color(0xFFFFEBEE);

  // Dark Mode Palette
  static const _darkPrimary = Color(0xFF818CF8);
  static const _darkOnPrimary = Color(0xFF0F0F14);
  static const _darkAccent = Color(0xFFF5A623);
  static const _darkOnAccent = Color(0xFF0F0F14);
  static const _darkSurface = Color(0xFF0F0F14);
  static const _darkSurfaceContainer = Color(0xFF18181F);
  static const _darkTextPrimary = Color(0xFFEDEDF5);
  static const _darkTextSecondary = Color(0xFF9E9EB0);
  static const _darkOutline = Color(0xFF2E2E40);
  static const _darkOutlineSubtle = Color(0xFF252538);
  static const _darkDisabled = Color(0xFF454558);
  static const _darkError = Color(0xFFEF5350);
  static const _darkErrorContainer = Color(0xFF3A1A1A);

  // ── Light mode ──────────────────────────────────────────────────────────

  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      primaryContainer: _lightPrimary.withValues(alpha: 0.12),
      onPrimaryContainer: _lightPrimary,
      secondary: _lightAccent,
      onSecondary: _lightOnAccent,
      secondaryContainer: _lightAccent.withValues(alpha: 0.12),
      onSecondaryContainer: _lightAccent,
      surface: _lightSurface,
      onSurface: _lightTextPrimary,
      surfaceContainerHighest: _lightSurfaceContainer,
      onSurfaceVariant: _lightTextSecondary,
      error: _lightError,
      onError: Colors.white,
      errorContainer: _lightErrorContainer,
      onErrorContainer: _lightError,
      outline: _lightOutline,
      outlineVariant: _lightOutlineSubtle,
      surfaceTint: Colors.transparent,
      shadow: _lightPrimary.withValues(alpha: 0.08),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _lightSurface,
      splashFactory: NoSplash.splashFactory,

      // ── Scroll physics ────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(true),
        thickness: WidgetStateProperty.all(3),
        radius: const Radius.circular(4),
      ),

      // ── Page transitions ──────────────────────────────────────────────
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: const CupertinoPageTransitionsBuilder(),
        },
      ),

      // ── Card ──────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: _lightPrimary.withValues(alpha: 0.03),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        color: _lightSurfaceContainer,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated button ───────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: _lightOnPrimary,
          disabledBackgroundColor: _lightPrimary.withValues(alpha: 0.38),
          disabledForegroundColor: _lightOnPrimary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          elevation: 0,
          shadowColor: _lightPrimary.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Outlined button ───────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimary,
          side: BorderSide(color: _lightPrimary.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Text button ──────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Input decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: _lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: _lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: _lightError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: _lightError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _lightTextSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _lightTextSecondary.withValues(alpha: 0.6),
        ),
      ),

      // ── Bottom navigation bar ─────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightSurfaceContainer,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: _lightDisabled,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),

      // ── App bar ───────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_chipRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
        backgroundColor: _lightPrimary.withValues(alpha: 0.08),
        selectedColor: _lightPrimary,
        disabledColor: _lightDisabled.withValues(alpha: 0.5),
        side: BorderSide.none,
      ),

      // ── Dialog ────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_dialogRadius),
        ),
        elevation: 8,
        shadowColor: _lightPrimary.withValues(alpha: 0.08),
      ),

      // ── Bottom sheet ──────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        dragHandleColor: _lightOutline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: _lightSurfaceContainer,
      ),

      // ── Snackbar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),

      // ── Text theme (Sora for headings, Inter for body) ────────────────
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.sora(
          fontSize: 44,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02,
          color: _lightTextPrimary,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          color: _lightTextPrimary,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          color: _lightTextPrimary,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: _lightTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _lightTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _lightTextPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _lightTextSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: _lightTextPrimary,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: _lightTextSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: _lightTextSecondary,
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: _lightOutline.withValues(alpha: 0.5),
      ),

      // ── SegmentedButton ───────────────────────────────────────────────
      // Styled per design system: 10dp radius, primary selection
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          selectedBackgroundColor: _lightPrimary.withValues(alpha: 0.12),
          selectedForegroundColor: _lightPrimary,
        ),
      ),
    );
  }

  // ── Dark mode ───────────────────────────────────────────────────────────

  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      primaryContainer: _darkPrimary.withValues(alpha: 0.15),
      onPrimaryContainer: _darkPrimary,
      secondary: _darkAccent,
      onSecondary: _darkOnAccent,
      secondaryContainer: _darkAccent.withValues(alpha: 0.15),
      onSecondaryContainer: _darkAccent,
      surface: _darkSurface,
      onSurface: _darkTextPrimary,
      surfaceContainerHighest: _darkSurfaceContainer,
      onSurfaceVariant: _darkTextSecondary,
      error: _darkError,
      onError: _darkSurface,
      errorContainer: _darkErrorContainer,
      onErrorContainer: _darkError,
      outline: _darkOutline,
      outlineVariant: _darkOutlineSubtle,
      surfaceTint: Colors.transparent,
      shadow: Colors.black.withValues(alpha: 0.2),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkSurface,
      splashFactory: NoSplash.splashFactory,

      // ── Scroll physics ────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(true),
        thickness: WidgetStateProperty.all(3),
        radius: const Radius.circular(4),
      ),

      // ── Page transitions ──────────────────────────────────────────────
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: const CupertinoPageTransitionsBuilder(),
        },
      ),

      // ── Card ──────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        color: _darkSurfaceContainer,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated button ───────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          disabledBackgroundColor: _darkPrimary.withValues(alpha: 0.3),
          disabledForegroundColor: _darkOnPrimary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Outlined button ───────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimary,
          side: BorderSide(color: _darkPrimary.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Text button ──────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Input decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: _darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: _darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: _darkError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: _darkError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _darkTextSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _darkTextSecondary.withValues(alpha: 0.6),
        ),
      ),

      // ── Bottom navigation bar ─────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurfaceContainer,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: _darkDisabled,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),

      // ── App bar ───────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_chipRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
        ),
        backgroundColor: _darkPrimary.withValues(alpha: 0.12),
        selectedColor: _darkPrimary,
        disabledColor: _darkDisabled.withValues(alpha: 0.5),
        side: BorderSide.none,
      ),

      // ── Dialog ────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_dialogRadius),
        ),
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // ── Bottom sheet ──────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        dragHandleColor: _darkOutline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: _darkSurfaceContainer,
      ),

      // ── Snackbar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),

      // ── Text theme (Sora for headings, Inter for body) ────────────────
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.sora(
          fontSize: 44,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02,
          color: _darkTextPrimary,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          color: _darkTextPrimary,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          color: _darkTextPrimary,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: _darkTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _darkTextPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _darkTextSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: _darkTextPrimary,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: _darkTextSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: _darkTextSecondary,
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: _darkOutline.withValues(alpha: 0.5),
      ),

      // ── SegmentedButton ───────────────────────────────────────────────
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          selectedBackgroundColor: _darkPrimary.withValues(alpha: 0.15),
          selectedForegroundColor: _darkPrimary,
        ),
      ),
    );
  }
}
