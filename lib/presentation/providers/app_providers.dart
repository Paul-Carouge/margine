import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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

// ---------------------------------------------------------------------------
// UI State providers
// ---------------------------------------------------------------------------

final monthlyGoalProvider = StateProvider<double>((ref) => 300.0);
final filterStatusProvider = StateProvider<String>((ref) => 'all');
final searchQueryProvider = StateProvider<String>((ref) => '');

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
int statusColorValue(String status) {
  switch (status) {
    case 'bought':
      return 0xFF3A8A6C;
    case 'listed':
      return 0xFF5B7FBF;
    case 'sold':
      return 0xFFD4A74D;
    default:
      return 0xFF8A8A98;
  }
}

/// Profit margin helpers.
double profitFor(Product p) {
  if (p.status != 'sold' || p.salePrice == null) return 0;
  return p.salePrice! - p.purchasePrice - p.vintedFees - p.shippingCost - p.packagingCost;
}

double marginPercent(Product p) {
  if (p.purchasePrice <= 0) return 0;
  final profit = profitFor(p);
  return (profit / p.purchasePrice) * 100;
}
