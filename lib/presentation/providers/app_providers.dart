import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/dao/category_dao.dart';
import '../../data/database/dao/product_dao.dart';

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

/// Singleton provider for [AppDatabase].
///
/// The database is kept alive for the entire application lifecycle.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ---------------------------------------------------------------------------
// DAOs
// ---------------------------------------------------------------------------

/// Provider for [CategoryDao].
final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final db = ref.watch(databaseProvider);
  return CategoryDao(db);
});

/// Provider for [ProductDao].
final productDaoProvider = Provider<ProductDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ProductDao(db);
});

// ---------------------------------------------------------------------------
// Stream providers
// ---------------------------------------------------------------------------

/// Streams all products ordered by most recently updated.
final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  final dao = ref.watch(productDaoProvider);
  return dao.watchAll();
});

/// Streams all categories ordered by name.
final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return dao.watchAll();
});

/// Streams products filtered by status.
final productsByStatusProvider =
    StreamProvider.family<List<Product>, String>((ref, status) {
  final dao = ref.watch(productDaoProvider);
  return dao.watchByStatus(status);
});

// ---------------------------------------------------------------------------
// Future providers
// ---------------------------------------------------------------------------

/// Fetches aggregate dashboard statistics.
final dashboardStatsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final dao = ref.watch(productDaoProvider);
  return dao.getStats();
});

/// Fetches a single product by its id.
final productByIdProvider =
    FutureProvider.family<Product?, int>((ref, id) async {
  final dao = ref.watch(productDaoProvider);
  return dao.getById(id);
});
