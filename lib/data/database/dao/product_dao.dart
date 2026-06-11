import 'package:drift/drift.dart';

import '../app_database.dart';

/// Data access object for the [Products] table.
class ProductDao extends DatabaseAccessor<AppDatabase> {
  ProductDao(super.attachedDatabase);

  /// Stream all products, newest first.
  Stream<List<Product>> watchAll() =>
      (select(attachedDatabase.products)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  /// Stream products filtered by status.
  Stream<List<Product>> watchByStatus(String status) =>
      (select(attachedDatabase.products)
            ..where((t) => t.status.equals(status))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  /// Get all products in a single shot.
  Future<List<Product>> getAll() =>
      (select(attachedDatabase.products)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .get();

  /// Get a single product by its primary key.
  Future<Product?> getById(int id) =>
      (select(attachedDatabase.products)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Get products whose purchase date falls within [start]–[end] (inclusive).
  Future<List<Product>> getByDateRange(DateTime start, DateTime end) =>
      (select(attachedDatabase.products)
            ..where(
                (t) => t.purchaseDate.isBetween(Variable(start), Variable(end)))
            ..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)]))
          .get();

  /// Aggregate statistics across all products.
  ///
  /// Returns a map with keys:
  ///   totalInvested, totalRevenue, totalProfit, count,
  ///   soldCount, listedCount, boughtCount.
  Future<Map<String, dynamic>> getStats() async {
    final all = await select(attachedDatabase.products).get();

    final sold = all.where((p) => p.status == 'sold').toList();
    final listed = all.where((p) => p.status == 'listed').toList();
    final bought = all.where((p) => p.status == 'bought').toList();

    final totalInvested =
        all.fold<double>(0, (sum, p) => sum + p.purchasePrice);

    final totalRevenue =
        sold.fold<double>(0, (sum, p) => sum + (p.salePrice ?? 0));

    final totalFees = sold.fold<double>(
      0,
      (sum, p) => sum + p.vintedFees + p.shippingCost + p.packagingCost,
    );

    final totalProfit = totalRevenue - totalInvested - totalFees;

    return {
      'totalInvested': totalInvested,
      'totalRevenue': totalRevenue,
      'totalProfit': totalProfit,
      'totalFees': totalFees,
      'count': all.length,
      'soldCount': sold.length,
      'listedCount': listed.length,
      'boughtCount': bought.length,
    };
  }

  /// Insert a new product. Returns the generated id.
  Future<int> insert(ProductsCompanion companion) =>
      into(attachedDatabase.products).insert(companion);

  /// Update an existing product (matched by id).
  Future<void> updateProduct(ProductsCompanion companion) =>
      update(attachedDatabase.products).replace(companion);

  /// Delete a product by its primary key.
  Future<void> deleteProduct(int id) =>
      (delete(attachedDatabase.products)..where((t) => t.id.equals(id)))
          .go();

  /// Get monthly revenue/profit stats grouped by (year, month).
  ///
  /// Returns a list of maps sorted by date ascending. Each map has keys:
  ///   year, month, invested, revenue, profit, count
  Future<List<Map<String, dynamic>>> getMonthlyStats() async {
    final all = await select(attachedDatabase.products).get();

    final Map<String, Map<String, dynamic>> groups = {};

    for (final p in all) {
      final key = '${p.purchaseDate.year}-${p.purchaseDate.month.toString().padLeft(2, '0')}';
      groups.putIfAbsent(key, () => {
        'year': p.purchaseDate.year,
        'month': p.purchaseDate.month,
        'invested': 0.0,
        'revenue': 0.0,
        'profit': 0.0,
        'count': 0,
      });
      groups[key]!['invested'] = (groups[key]!['invested'] as double) + p.purchasePrice;
      groups[key]!['count'] = (groups[key]!['count'] as int) + 1;
      if (p.status == 'sold' && p.salePrice != null) {
        groups[key]!['revenue'] = (groups[key]!['revenue'] as double) + p.salePrice!;
        groups[key]!['profit'] = (groups[key]!['profit'] as double) +
            p.salePrice! - p.purchasePrice - p.vintedFees - p.shippingCost - p.packagingCost;
      }
    }

    final sorted = groups.values.toList()
      ..sort((a, b) {
        final ya = a['year'] as int;
        final yb = b['year'] as int;
        if (ya != yb) return ya.compareTo(yb);
        return (a['month'] as int).compareTo(b['month'] as int);
      });

    return sorted;
  }
}
