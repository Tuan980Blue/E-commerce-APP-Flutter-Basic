import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/database/database_helper.dart';

class ProductData {
  static Future<void> loadProductsFromJson() async {
    try {
      // Đọc file JSON
      final String jsonString = await rootBundle.loadString('assets/files/productlist.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> products = jsonData['data'];

      final dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      // Xóa dữ liệu cũ
      await db.delete('Product');

      // Thêm dữ liệu mới từ JSON
      for (var product in products) {
        await db.insert('Product', {
          'name': product['name'],
          'price': product['price'].toDouble(),
          'img': product['img'],
          'desc': 'Sản phẩm ${product['name']} chất lượng cao',
          'catId': product['categoryId'],
          'soldCount': product['soldCount'] ?? 0,
        });
      }

      print('Đã load ${products.length} sản phẩm từ JSON vào database');
    } catch (e) {
      print('Lỗi khi load dữ liệu sản phẩm: $e');
    }
  }

  static Future<void> loadCategoriesFromJson() async {
    try {
      // Đọc file JSON
      final String jsonString = await rootBundle.loadString('assets/files/categorylist.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> categories = jsonData['data'];

      final dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      // Xóa dữ liệu cũ
      await db.delete('Category');

      // Thêm dữ liệu mới từ JSON
      for (var category in categories) {
        await db.insert('Category', {
          'name': category['name'],
          'desc': 'Danh mục ${category['name']}',
        });
      }

      print('Đã load ${categories.length} danh mục từ JSON vào database');
    } catch (e) {
      print('Lỗi khi load dữ liệu danh mục: $e');
    }
  }

  static Future<void> loadAllDataFromJson() async {
    await loadCategoriesFromJson();
    await loadProductsFromJson();
  }
}
