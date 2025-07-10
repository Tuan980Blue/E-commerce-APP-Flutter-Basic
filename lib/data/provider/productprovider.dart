import 'package:flutter/material.dart';
import '../model/productmodel.dart';
import '../database/database_helper.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _loading = false;
  String? _error;
  ProductModel? _selectedProduct;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Getters
  List<ProductModel> get products => _products;
  bool get loading => _loading;
  String? get error => _error;
  ProductModel? get selectedProduct => _selectedProduct;

  // Load products from database
  Future<void> loadProducts() async {
    try {
      _setLoading(true);
      _setError(null);
      
      final List<Map<String, dynamic>> maps = await _dbHelper.getAllProducts();
      _products = maps.map((map) => ProductModel.fromMap(map)).toList();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load products: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get products by category ID
  List<ProductModel> getProductsByCategory(int categoryId) {
    return _products
        .where((product) => product.catId == categoryId)
        .toList();
  }

  // Select a product
  void selectProduct(ProductModel product) {
    _selectedProduct = product;
    notifyListeners();
  }

  // Clear selected product
  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  // Get product by ID
  ProductModel? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search products by name
  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products
        .where((product) => 
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Search products by name within a category
  List<ProductModel> searchProductsInCategory(String query, int categoryId) {
    final categoryProducts = getProductsByCategory(categoryId);
    if (query.isEmpty) return categoryProducts;
    
    return categoryProducts
        .where((product) => 
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Filter products by price range
  List<ProductModel> filterProductsByPrice(double minPrice, double maxPrice) {
    return _products
        .where((product) => 
            product.price >= minPrice && product.price <= maxPrice)
        .toList();
  }

  // Filter products by price range within a category
  List<ProductModel> filterProductsByPriceInCategory(
      double minPrice, double maxPrice, int categoryId) {
    final categoryProducts = getProductsByCategory(categoryId);
    return categoryProducts
        .where((product) => 
            product.price >= minPrice && product.price <= maxPrice)
        .toList();
  }

  // Sort products by price (ascending)
  List<ProductModel> sortProductsByPrice(List<ProductModel> products, {bool ascending = true}) {
    final sorted = List<ProductModel>.from(products);
    if (ascending) {
      sorted.sort((a, b) => a.price.compareTo(b.price));
    } else {
      sorted.sort((a, b) => b.price.compareTo(a.price));
    }
    return sorted;
  }

  // Sort products by name
  List<ProductModel> sortProductsByName(List<ProductModel> products, {bool ascending = true}) {
    final sorted = List<ProductModel>.from(products);
    if (ascending) {
      sorted.sort((a, b) => a.name.compareTo(b.name));
    } else {
      sorted.sort((a, b) => b.name.compareTo(a.name));
    }
    return sorted;
  }

  // Sort products by sold count
  List<ProductModel> sortProductsBySoldCount(List<ProductModel> products, {bool ascending = true}) {
    final sorted = List<ProductModel>.from(products);
    if (ascending) {
      sorted.sort((a, b) => a.soldCount.compareTo(b.soldCount));
    } else {
      sorted.sort((a, b) => b.soldCount.compareTo(a.soldCount));
    }
    return sorted;
  }

  // Add new product
  Future<bool> addProduct(ProductModel product) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final id = await _dbHelper.insertProduct(product.toMap());
      if (id > 0) {
        final newProduct = product.copyWith(id: id);
        _products.insert(0, newProduct);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to add product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final result = await _dbHelper.updateProduct(product.toMap());
      if (result > 0) {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _setError('Failed to update product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final result = await _dbHelper.deleteProduct(id);
      if (result > 0) {
        _products.removeWhere((product) => product.id == id);
        if (_selectedProduct?.id == id) {
          _selectedProduct = null;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to delete product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle product availability
  void toggleProductAvailability(int id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        isAvailable: !_products[index].isAvailable
      );
      notifyListeners();
    }
  }

  // Update sold count for a product
  Future<bool> updateSoldCount(int id, int newSoldCount) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        final updatedProduct = _products[index].copyWith(soldCount: newSoldCount);
        final result = await _dbHelper.updateProduct(updatedProduct.toMap());
        if (result > 0) {
          _products[index] = updatedProduct;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _setError('Failed to update sold count: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Increment sold count for a product
  Future<bool> incrementSoldCount(int id, {int increment = 1}) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        final newSoldCount = _products[index].soldCount + increment;
        final updatedProduct = _products[index].copyWith(soldCount: newSoldCount);
        final result = await _dbHelper.updateProduct(updatedProduct.toMap());
        if (result > 0) {
          _products[index] = updatedProduct;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _setError('Failed to increment sold count: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get top selling products
  List<ProductModel> getTopSellingProducts({int limit = 10}) {
    final sorted = List<ProductModel>.from(_products);
    sorted.sort((a, b) => b.soldCount.compareTo(a.soldCount));
    return sorted.take(limit).toList();
  }

  // Get products by sold count range
  List<ProductModel> getProductsBySoldCountRange(int minSold, int maxSold) {
    return _products
        .where((product) => 
            product.soldCount >= minSold && product.soldCount <= maxSold)
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