class CartModel {
  final int? id;
  final int productId;
  final String productName;
  final double price;
  final String? productImage;
  final int quantity;

  CartModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.productImage,
    required this.quantity,
  });

  // Tạo từ Map (từ database)
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      productImage: map['productImage'],
      quantity: map['quantity'] ?? 1,
    );
  }

  // Chuyển thành Map (để lưu vào database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'productImage': productImage,
      'quantity': quantity,
    };
  }

  // Tạo bản sao với các thay đổi
  CartModel copyWith({
    int? id,
    int? productId,
    String? productName,
    double? price,
    String? productImage,
    int? quantity,
  }) {
    return CartModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      productImage: productImage ?? this.productImage,
      quantity: quantity ?? this.quantity,
    );
  }

  // Tính tổng giá của item này
  double get totalPrice => price * quantity;

  // Format giá tiền theo định dạng Việt Nam
  String get formattedPrice {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match m) => "${m[1]}."
    )} đ';
  }

  String get formattedTotalPrice {
    return '${totalPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match m) => "${m[1]}."
    )} đ';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartModel && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;

  @override
  String toString() {
    return 'CartModel(id: $id, productId: $productId, productName: $productName, quantity: $quantity)';
  }
} 