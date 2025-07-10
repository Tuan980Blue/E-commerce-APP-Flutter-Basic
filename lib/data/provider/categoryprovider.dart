import 'package:flutter/material.dart';
import '../model/categorymodel.dart';
import '../database/database_helper.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _loading = false;
  String? _error;
  CategoryModel? _selectedCategory;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Getters
  List<CategoryModel> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;
  CategoryModel? get selectedCategory => _selectedCategory;

  // Load categories from database
  Future<void> loadCategories() async {
    try {
      _setLoading(true);
      _setError(null);
      
      final List<Map<String, dynamic>> maps = await _dbHelper.getAllCategories();
      _categories = maps.map((map) => CategoryModel.fromMap(map)).toList();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load categories: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add new category
  Future<bool> addCategory(CategoryModel category) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final id = await _dbHelper.insertCategory(category.toMap());
      if (id > 0) {
        final newCategory = category.copyWith(id: id);
        _categories.insert(0, newCategory);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to add category: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final result = await _dbHelper.updateCategory(category.toMap());
      if (result > 0) {
        final index = _categories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _categories[index] = category;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _setError('Failed to update category: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final result = await _dbHelper.deleteCategory(id);
      if (result > 0) {
        _categories.removeWhere((category) => category.id == id);
        if (_selectedCategory?.id == id) {
          _selectedCategory = null;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to delete category: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Select a category
  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Clear selected category
  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  // Get category by ID
  CategoryModel? getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search categories by name
  List<CategoryModel> searchCategories(String query) {
    if (query.isEmpty) return _categories;
    
    return _categories
        .where((category) => 
            category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Private methods
  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _setError(null);
  }
}
