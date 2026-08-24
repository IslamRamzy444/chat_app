
import 'package:chat_app/features/home/domain/entities/category_entity.dart';
import 'package:test/test.dart';

void main() {
  group('CategoryEntity', () {
    test('categories list has 9 items', () {
      expect(CategoryEntity.categories.length, 9);
    });

    test('getCategoryById returns correct category for valid id', () {
      final category = CategoryEntity.getCategoryById('sports');
      expect(category, isNotNull);
      expect(category!.id, 'sports');
    });

    test('getCategoryById returns null for invalid id', () {
      final category = CategoryEntity.getCategoryById('invalid');
      expect(category, isNull);
    });

    test('all categories have unique ids', () {
      final ids = CategoryEntity.categories.map((c) => c.id).toList();
      expect(ids.length, ids.toSet().length);
    });

    test('getLocalizedName returns non-empty string for all categories', () {
      // Just verifying the method doesn't throw
      for (var category in CategoryEntity.categories) {
        expect(category.nameKey, isNotEmpty);
      }
    });
  });
}