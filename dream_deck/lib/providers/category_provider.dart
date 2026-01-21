import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  late Box<DreamCategoryModel> _categoryBox;
  List<DreamCategoryModel> _categories = [];

  List<DreamCategoryModel> get categories => _categories;

  Future<void> initialize() async {
    _categoryBox = await Hive.openBox<DreamCategoryModel>('categories');
    
    // Initialize with default categories if box is empty
    if (_categoryBox.isEmpty) {
      for (var category in DreamCategoryModel.defaultCategories) {
        await _categoryBox.put(category.id, category);
      }
    }
    
    _loadCategories();
  }

  void _loadCategories() {
    _categories = _categoryBox.values.toList();
    // Sort: default categories first, then custom ones by creation order
    _categories.sort((a, b) {
      if (a.isDefault && !b.isDefault) return -1;
      if (!a.isDefault && b.isDefault) return 1;
      return 0;
    });
    notifyListeners();
  }

  Future<void> addCategory(DreamCategoryModel category) async {
    await _categoryBox.put(category.id, category);
    _loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    // Don't allow deleting default categories
    final category = _categoryBox.get(id);
    if (category?.isDefault == true) return;
    
    await _categoryBox.delete(id);
    _loadCategories();
  }

  DreamCategoryModel? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  List<DreamCategoryModel> get customCategories {
    return _categories.where((c) => !c.isDefault).toList();
  }

  List<DreamCategoryModel> get defaultCategories {
    return _categories.where((c) => c.isDefault).toList();
  }
}
