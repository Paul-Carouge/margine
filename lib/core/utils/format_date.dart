/// Shared date formatting utilities for L'Établi.
///
/// Used by home_screen, product_card, and any widget that displays dates.
class FormatDate {
  FormatDate._();

  /// Formats to dd/mm (day/month) — used on product cards.
  static String short(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  /// Formats to dd/mm/yyyy — used in detail sheets.
  static String full(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
