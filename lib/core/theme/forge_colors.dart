import 'package:flutter/material.dart';

/// Forge palette — L'Établi v3.0.0 "Forge"
///
/// Three pillars:
///   - **Crimson**   #C0392B — Primary actions, selections, FAB
///   - **Teal**      #14B8A6 — Profit, success, sold status
///   - **Graphite**  #15151C — Background, the workbench itself
///
/// Dark mode first. Light palette derived secondarily.
class ForgeColors {
  ForgeColors._();

  // ────────────────────────────────────────────────────────────────────────────
  // DARK PALETTE (primary mode)
  // ────────────────────────────────────────────────────────────────────────────

  /// Primary — Crimson #C0392B. The heart of the forge.
  static const Color crimson = Color(0xFFC0392B);

  /// Hover/pressed state on dark backgrounds.
  static const Color crimsonBright = Color(0xFFD44646);

  /// Selected chips, tinted containers (15% opacity over dark).
  static const Color crimsonContainer = Color(0x26C0392B);

  /// Subtly tinted surfaces (7% opacity).
  static const Color crimsonSurface = Color(0x12C0392B);

  /// Accent — Precision Teal #14B8A6. The precision tool.
  static const Color teal = Color(0xFF14B8A6);

  /// Muted variant for secondary icons, filled gauges.
  static const Color tealMuted = Color(0xFF0D9488);

  /// Teal badge background (10% opacity).
  static const Color tealContainer = Color(0x1A14B8A6);

  // Backgrounds — Warm Graphite family
  /// Main background — the workbench. Never pure black.
  static const Color bg = Color(0xFF15151C);

  /// Elevated surfaces, cards in dark mode.
  static const Color surface = Color(0xFF1E1E28);

  /// Higher elevation surfaces, hover cards.
  static const Color surfaceElevated = Color(0xFF282836);

  /// Overlay for bottom sheets.
  static const Color surfaceOverlay = Color(0xFF2A2A35);

  // Text & Outlines
  /// Primary text — warm white, not sterile.
  static const Color textPrimary = Color(0xFFF0EDE5);

  /// Secondary text, labels.
  static const Color textSecondary = Color(0xFF8A8A95);

  /// Disabled text, placeholders.
  static const Color textDisabled = Color(0xFF5A5A65);

  /// Borders, separators.
  static const Color outline = Color(0xFF2E2E3A);

  /// Accented borders, drag handles.
  static const Color outlineStrong = Color(0xFF3E3E4C);

  /// Very thin separators, card hairlines.
  static const Color outlineSubtle = Color(0xFF252530);

  // Semantic
  /// Errors, deletion, loss.
  static const Color error = Color(0xFFD94A3D);

  /// Error background (10% opacity).
  static const Color errorContainer = Color(0x1AD94A3D);

  /// Warnings (rare).
  static const Color warning = Color(0xFFCA8A04);

  // Status badges (dark mode)
  /// 'bought' → secondary text on Outline Container
  static const Color statusBought = textSecondary;
  /// 'listed' → Crimson container, crimson text
  /// (use crimson/crimsonContainer directly)
  static const Color statusListed = crimson;
  /// 'sold' → Teal container, teal text
  /// (use teal/tealContainer directly)
  static const Color statusSold = teal;

  // ────────────────────────────────────────────────────────────────────────────
  // LIGHT PALETTE (secondary mode — the lit workshop)
  // ────────────────────────────────────────────────────────────────────────────

  static const Color lightBg = Color(0xFFF8F6F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF0EDE5);
  static const Color lightTextPrimary = Color(0xFF1A1A22);
  static const Color lightTextSecondary = Color(0xFF6B6B78);
  static const Color lightOutline = Color(0xFFD6D0C8);

  /// Crimson adjusted for light backgrounds (better contrast).
  static const Color lightCrimson = Color(0xFFB3302A);

  /// Teal adjusted for light backgrounds.
  static const Color lightTeal = Color(0xFF0D9488);

  // ────────────────────────────────────────────────────────────────────────────
  // ColorScheme builders
  // ────────────────────────────────────────────────────────────────────────────

  static ColorScheme darkScheme() => ColorScheme.dark(
        primary: crimson,
        onPrimary: textPrimary,
        primaryContainer: crimsonContainer,
        onPrimaryContainer: crimson,
        secondary: tealMuted,
        onSecondary: bg,
        surface: bg,
        onSurface: textPrimary,
        surfaceContainerHighest: surface,
        onSurfaceVariant: textSecondary,
        error: error,
        onError: bg,
        outline: outline,
        outlineVariant: outline.withValues(alpha: 0.4),
        surfaceTint: Colors.transparent,
      );

  static ColorScheme lightScheme() => ColorScheme.light(
        primary: lightCrimson,
        onPrimary: Colors.white,
        primaryContainer: lightCrimson.withValues(alpha: 0.12),
        onPrimaryContainer: lightCrimson,
        secondary: lightTeal,
        onSecondary: Colors.white,
        surface: lightBg,
        onSurface: lightTextPrimary,
        surfaceContainerHighest: lightSurface,
        onSurfaceVariant: lightTextSecondary,
        error: error,
        onError: Colors.white,
        outline: lightOutline,
        outlineVariant: lightOutline.withValues(alpha: 0.4),
        surfaceTint: Colors.transparent,
      );
}
