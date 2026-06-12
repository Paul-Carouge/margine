import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/theme/forge_colors.dart';
import '../../data/database/app_database.dart';
import '../../data/database/dao/category_dao.dart';
import '../../data/database/dao/product_dao.dart';

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ---------------------------------------------------------------------------
// DAOs
// ---------------------------------------------------------------------------

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  return CategoryDao(ref.watch(databaseProvider));
});

final productDaoProvider = Provider<ProductDao>((ref) {
  return ProductDao(ref.watch(databaseProvider));
});

// ---------------------------------------------------------------------------
// Stream providers
// ---------------------------------------------------------------------------

final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productDaoProvider).watchAll();
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryDaoProvider).watchAll();
});

final productsByStatusProvider =
    StreamProvider.family<List<Product>, String>((ref, status) {
  return ref.watch(productDaoProvider).watchByStatus(status);
});

// ---------------------------------------------------------------------------
// Future providers
// ---------------------------------------------------------------------------

final dashboardStatsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(productsStreamProvider);
  return ref.watch(productDaoProvider).getStats();
});

final productByIdProvider =
    FutureProvider.family<Product?, int>((ref, id) async {
  return ref.watch(productDaoProvider).getById(id);
});

final monthlyStatsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(productsStreamProvider);
  return ref.watch(productDaoProvider).getMonthlyStats();
});

// ---------------------------------------------------------------------------
// UI State providers
// ---------------------------------------------------------------------------

final monthlyGoalProvider = StateProvider<double>((ref) => 300.0);
final filterStatusProvider = StateProvider<String>((ref) => 'all');
final searchQueryProvider = StateProvider<String>((ref) => '');
final showSearchProvider = StateProvider<bool>((ref) => false);

/// Couleur d'accent du thème (Crimson par défaut).
/// La sauvegarde dans SharedPreferences est gérée automatiquement
/// dans main.dart via ref.listen.
final accentColorProvider = StateProvider<Color>(
  (ref) => ForgeColors.crimson,
);

enum SortOption { dateDesc, profitDesc, priceDesc, nameAsc }

final sortOptionProvider =
    StateProvider<SortOption>((ref) => SortOption.dateDesc);

/// Returns the display name for a status key.
String statusLabel(String status) {
  switch (status) {
    case 'bought':
      return 'En stock';
    case 'listed':
      return 'En ligne';
    case 'sold':
      return 'Vendu';
    default:
      return 'Tout';
  }
}

/// Returns the semantic color for a status key.
Color statusColor(String status) {
  switch (status) {
    case 'bought':
      return ForgeColors.textSecondary;
    case 'listed':
      return ForgeColors.crimson;
    case 'sold':
      return ForgeColors.teal;
    default:
      return ForgeColors.textSecondary;
  }
}

/// Returns the int color value for a status key (used in DB).
int statusColorValue(String status) {
  return statusColor(status).toARGB32();
}

/// Profit margin helpers.
double profitFor(Product p) {
  if (p.status != 'sold' || p.salePrice == null) return 0;
  return p.salePrice! -
      p.purchasePrice -
      p.vintedFees -
      p.shippingCost -
      p.packagingCost;
}

double marginPercent(Product p) {
  if (p.purchasePrice <= 0) return 0;
  final profit = profitFor(p);
  return (profit / p.purchasePrice) * 100;
}
