/// Application-wide constants for Margine.
class AppConstants {
  AppConstants._();

  /// App display name.
  static const String appName = 'Margine';

  /// Currency symbol used throughout the app.
  static const String currency = '€';

  /// Default icons for predefined categories.
  static const Map<String, String> defaultCategoryIcons = {
    'Montres': 'watch',
    'Vêtements': 'checkroom',
    'Chaussures': 'sports_handball',
    'Accessoires': 'backpack',
    'Électronique': 'devices',
  };

  /// Human-readable status labels keyed by internal status value.
  static const Map<String, String> statusLabels = {
    'bought': 'Acheté',
    'listed': 'En vente',
    'sold': 'Vendu',
  };

  /// Human-readable source labels keyed by internal source value.
  static const Map<String, String> sourceLabels = {
    'vinted': 'Vinted',
    'leboncoin': 'Leboncoin',
    'ebay': 'eBay',
    'other': 'Autre',
  };
}
