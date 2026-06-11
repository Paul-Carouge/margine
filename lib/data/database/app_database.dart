import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Table definitions
// ---------------------------------------------------------------------------

/// Product categories (e.g. Montres, Vêtements, …).
@UseRowClass(Category)
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconCode => text()();
  IntColumn get colorValue => integer()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Products tracked by the user.
@UseRowClass(Product)
@TableIndex(name: 'idx_products_status', columns: {#status})
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.setNull)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get purchasePrice => real()();
  DateTimeColumn get purchaseDate => dateTime()();
  TextColumn get source => text()();
  TextColumn get status => text()();
  RealColumn get listingPrice => real().nullable()();
  RealColumn get minPrice => real().nullable()();
  RealColumn get salePrice => real().nullable()();
  DateTimeColumn get saleDate => dateTime().nullable()();
  RealColumn get vintedFees => real().withDefault(const Constant(0.0))();
  RealColumn get shippingCost => real().withDefault(const Constant(0.0))();
  RealColumn get packagingCost => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// ---------------------------------------------------------------------------
// Row classes
// ---------------------------------------------------------------------------

/// Data class for a single category row.
class Category {
  final int id;
  final String name;
  final String iconCode;
  final int colorValue;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.createdAt,
  });

  @override
  String toString() =>
      'Category(id: $id, name: $name, iconCode: $iconCode, colorValue: $colorValue)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Data class for a single product row.
class Product {
  final int id;
  final String name;
  final String? description;
  final int categoryId;
  final int quantity;
  final double purchasePrice;
  final DateTime purchaseDate;
  final String source;
  final String status;
  final double? listingPrice;
  final double? minPrice;
  final double? salePrice;
  final DateTime? saleDate;
  final double vintedFees;
  final double shippingCost;
  final double packagingCost;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    this.quantity = 1,
    required this.purchasePrice,
    required this.purchaseDate,
    required this.source,
    required this.status,
    this.listingPrice,
    this.minPrice,
    this.salePrice,
    this.saleDate,
    this.vintedFees = 0.0,
    this.shippingCost = 0.0,
    this.packagingCost = 0.0,
    this.notes,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() => 'Product(id: $id, name: $name, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [Categories, Products],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(products, products.quantity);
          }
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            _seedDefaultCategories();
          }
        },
      );

  // -----------------------------------------------------------------------
  // Seed data
  // -----------------------------------------------------------------------

  Future<void> _seedDefaultCategories() async {
    await batch((batch) {
      batch.insertAll(
        categories,
        [
          CategoriesCompanion.insert(
            name: 'Montres',
            iconCode: 'watch',
            colorValue: 0xFF6C63FF,
          ),
          CategoriesCompanion.insert(
            name: 'Vêtements',
            iconCode: 'checkroom',
            colorValue: 0xFFE91E63,
          ),
          CategoriesCompanion.insert(
            name: 'Chaussures',
            iconCode: 'sports_handball',
            colorValue: 0xFF4CAF50,
          ),
          CategoriesCompanion.insert(
            name: 'Accessoires',
            iconCode: 'backpack',
            colorValue: 0xFFFF9800,
          ),
          CategoriesCompanion.insert(
            name: 'Électronique',
            iconCode: 'devices',
            colorValue: 0xFF2196F3,
          ),
        ],
      );
    });
  }

  // -----------------------------------------------------------------------
  // Connection
  // -----------------------------------------------------------------------

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'margine.db'));
      return NativeDatabase(file);
    });
  }
}
