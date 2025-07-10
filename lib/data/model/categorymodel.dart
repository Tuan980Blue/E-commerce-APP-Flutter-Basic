class CategoryModel {
  final int? id;
  final String name;
  final String? desc;

  CategoryModel({
    this.id,
    required this.name,
    this.desc,
  });

  // Tạo từ Map (từ database)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'] ?? '',
      desc: map['desc'],
    );
  }

  // Chuyển thành Map (để lưu vào database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
    };
  }

  // Tạo bản sao với các thay đổi
  CategoryModel copyWith({
    int? id,
    String? name,
    String? desc,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, desc: $desc)';
  }
}
