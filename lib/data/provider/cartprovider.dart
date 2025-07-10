import 'package:flutter/material.dart';
import '../model/cartmodel.dart';
import '../model/productmodel.dart';
import '../database/database_helper.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _cartItems = [];
  bool _loading = false;
  String? _error;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Getters
  List<CartModel> get cartItems => _cartItems;
  bool get loading => _loading;
  String? get error => _error;
  int get itemCount => _cartItems.length;
  
  // Tính tổng giá trị giỏ hàng
  double get totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Format tổng giá trị
  String get formattedTotalAmount {
    return '${totalAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match m) => "${m[1]}."
    )} đ';
  }

  // Load cart items from database
  Future<void> loadCartItems() async {
    try {
      _setLoading(true);
      _setError(null);
      
      final List<Map<String, dynamic>> maps = await _dbHelper.getAllCartItems();
      _cartItems = maps.map((map) => CartModel.fromMap(map)).toList();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load cart items: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add item to cart
  Future<bool> addToCart(ProductModel product, {int quantity = 1}) async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      final existingItem = _cartItems.firstWhere(
        (item) => item.productId == product.id,
        orElse: () => CartModel(
          productId: -1,
          productName: '',
          price: 0,
          quantity: 0,
        ),
      );

      if (existingItem.productId != -1) {
        // Nếu đã có, tăng số lượng
        return await updateCartItemQuantity(existingItem.id!, existingItem.quantity + quantity);
      } else {
        // Nếu chưa có, thêm mới
        final cartItem = CartModel(
          productId: product.id!,
          productName: product.name,
          price: product.price,
          productImage: product.img,
          quantity: quantity,
        );
        
        final id = await _dbHelper.insertCartItem(cartItem.toMap());
        if (id > 0) {
          final newCartItem = cartItem.copyWith(id: id);
          _cartItems.insert(0, newCartItem);
          notifyListeners();
          return true;
        }
        return false;
      }
    } catch (e) {
      _setError('Failed to add to cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update cart item quantity
  Future<bool> updateCartItemQuantity(int cartItemId, int newQuantity) async {
    try {
      _setLoading(true);
      _setError(null);
      
      if (newQuantity <= 0) {
        return await removeFromCart(cartItemId);
      }
      
      final index = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (index != -1) {
        final updatedItem = _cartItems[index].copyWith(quantity: newQuantity);
        final result = await _dbHelper.updateCartItem(updatedItem.toMap());
        if (result > 0) {
          _cartItems[index] = updatedItem;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _setError('Failed to update cart item: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart(int cartItemId) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final result = await _dbHelper.deleteCartItem(cartItemId);
      if (result > 0) {
        _cartItems.removeWhere((item) => item.id == cartItemId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to remove from cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear cart
  Future<bool> clearCart() async {
    try {
      _setLoading(true);
      _setError(null);
      
      final result = await _dbHelper.clearCart();
      if (result > 0) {
        _cartItems.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to clear cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check if product is in cart
  bool isProductInCart(int productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  // Get cart item by product ID
  CartModel? getCartItemByProductId(int productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
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