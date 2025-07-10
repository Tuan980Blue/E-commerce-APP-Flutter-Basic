class ProductModel {
  final int? id;
  final String name;
  final double price;
  final String? img;
  final String? desc;
  final int? catId;
  final bool isAvailable;
  final int soldCount; // Số lượng đã bán

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    this.img,
    this.desc,
    this.catId,
    this.isAvailable = true,
    this.soldCount = 0,
  });

  // Tạo từ Map (từ database)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      img: map['img'],
      desc: map['desc'],
      catId: map['catId'],
      isAvailable: map['isAvailable'] == 1,
      soldCount: map['soldCount'] ?? 0,
    );
  }

  // Chuyển thành Map (để lưu vào database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'img': img,
      'desc': desc,
      'catId': catId,
      'isAvailable': isAvailable ? 1 : 0,
      'soldCount': soldCount,
    };
  }

  // Tạo bản sao với các thay đổi
  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    String? img,
    String? desc,
    int? catId,
    bool? isAvailable,
    int? soldCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      img: img ?? this.img,
      desc: desc ?? this.desc,
      catId: catId ?? this.catId,
      isAvailable: isAvailable ?? this.isAvailable,
      soldCount: soldCount ?? this.soldCount,
    );
  }

  // Format giá tiền theo định dạng Việt Nam
  String get formattedPrice {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match m) => "${m[1]}."
    )} đ';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, catId: $catId, soldCount: $soldCount)';
  }
}
