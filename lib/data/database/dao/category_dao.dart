import 'package:drift/drift.dart';

import '../app_database.dart';

/// Data access object for the [Categories] table.
class CategoryDao extends DatabaseAccessor<AppDatabase> {
  CategoryDao(super.attachedDatabase);

  /// Stream all categories, ordered by name.
  Stream<List<Category>> watchAll() =>
      (select(attachedDatabase.categories)
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  /// Get all categories in a single shot.
  Future<List<Category>> getAll() =>
      (select(attachedDatabase.categories)
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  /// Get a single category by its primary key.
  Future<Category?> getById(int id) =>
      (select(attachedDatabase.categories)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Insert a new category. Returns the generated id.
  Future<int> insert(CategoriesCompanion companion) =>
      into(attachedDatabase.categories).insert(companion);

  /// Update an existing category (matched by id).
  Future<void> updateCategory(CategoriesCompanion companion) =>
      update(attachedDatabase.categories).replace(companion);

  /// Delete a category by its primary key.
  Future<void> deleteCategory(int id) =>
      (delete(attachedDatabase.categories)..where((t) => t.id.equals(id)))
          .go();
}
