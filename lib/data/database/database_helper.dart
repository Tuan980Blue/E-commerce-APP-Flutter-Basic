import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'db_product.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tạo bảng Category
    await db.execute('''
      CREATE TABLE Category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        desc TEXT
      )
    ''');

    // Tạo bảng Product
    await db.execute('''
      CREATE TABLE Product (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        img TEXT,
        desc TEXT,
        catId INTEGER,
        isAvailable INTEGER DEFAULT 1,
        soldCount INTEGER DEFAULT 0
      )
    ''');

    // Tạo bảng Cart
    await db.execute('''
      CREATE TABLE Cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        price REAL NOT NULL,
        productImage TEXT,
        quantity INTEGER DEFAULT 1
      )
    ''');

    // Thêm dữ liệu mẫu cho Category
    await db.insert('Category', {
      'name': 'Thời trang',
      'desc': 'Các sản phẩm thời trang nam nữ'
    });
    await db.insert('Category', {
      'name': 'Điện tử',
      'desc': 'Thiết bị điện tử công nghệ'
    });
    await db.insert('Category', {
      'name': 'Gia dụng',
      'desc': 'Đồ gia dụng nhà bếp'
    });

    // Thêm dữ liệu mẫu cho Product với soldCount
    await db.insert('Product', {
      'name': 'Áo đá bóng',
      'price': 29990000,
      'img': 'fashion1.png',
      'desc': 'Áo đá bóng chất lượng cao',
      'catId': 1,
      'soldCount': 45,
    });
    await db.insert('Product', {
      'name': 'Đồ bộ trẻ trung',
      'price': 19990000,
      'img': 'fashion2.png',
      'desc': 'Đồ bộ thời trang trẻ trung',
      'catId': 1,
      'soldCount': 32,
    });
    await db.insert('Product', {
      'name': 'Cục sạc nhanh',
      'price': 21990000,
      'img': 'PhonesAccessories1.png',
      'desc': 'Cục sạc nhanh công nghệ mới',
      'catId': 2,
      'soldCount': 78,
    });
    await db.insert('Product', {
      'name': 'Iphone 12 ProMax',
      'price': 8990000,
      'img': 'PhonesAccessories2.png',
      'desc': 'Điện thoại iPhone 12 ProMax',
      'catId': 2,
      'soldCount': 156,
    });
    await db.insert('Product', {
      'name': 'Loa bluetooth',
      'price': 8990000,
      'img': 'Electronics1.png',
      'desc': 'Loa bluetooth chất lượng cao',
      'catId': 3,
      'soldCount': 89,
    });
    await db.insert('Product', {
      'name': 'Đầu chuyển đổi HDMI',
      'price': 4990000,
      'img': 'Electronics2.png',
      'desc': 'Đầu chuyển đổi HDMI-VGA',
      'catId': 3,
      'soldCount': 67,
    });
  }

  // Migration function
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Thêm cột soldCount vào bảng Product nếu chưa có
      try {
        await db.execute('ALTER TABLE Product ADD COLUMN soldCount INTEGER DEFAULT 0');
      } catch (e) {
        // Cột đã tồn tại, bỏ qua lỗi
      }

      // Tạo bảng Cart
      await db.execute('''
        CREATE TABLE Cart (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId INTEGER NOT NULL,
          productName TEXT NOT NULL,
          price REAL NOT NULL,
          productImage TEXT,
          quantity INTEGER DEFAULT 1
        )
      ''');
    }
  }

  // CRUD Operations cho Category
  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.insert('Category', category);
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    return await db.query('Category', orderBy: 'id DESC');
  }

  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final db = await database;
    final results = await db.query(
      'Category',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.update(
      'Category',
      category,
      where: 'id = ?',
      whereArgs: [category['id']],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'Category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD Operations cho Product
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('Product', product);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query('Product', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(int catId) async {
    final db = await database;
    return await db.query(
      'Product',
      where: 'catId = ?',
      whereArgs: [catId],
      orderBy: 'id DESC',
    );
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final db = await database;
    final results = await db.query(
      'Product',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'Product',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'Product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD Operations cho Cart
  Future<int> insertCartItem(Map<String, dynamic> cartItem) async {
    final db = await database;
    return await db.insert('Cart', cartItem);
  }

  Future<List<Map<String, dynamic>>> getAllCartItems() async {
    final db = await database;
    return await db.query('Cart', orderBy: 'id DESC');
  }

  Future<Map<String, dynamic>?> getCartItemByProductId(int productId) async {
    final db = await database;
    final results = await db.query(
      'Cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateCartItem(Map<String, dynamic> cartItem) async {
    final db = await database;
    return await db.update(
      'Cart',
      cartItem,
      where: 'id = ?',
      whereArgs: [cartItem['id']],
    );
  }

  Future<int> deleteCartItem(int id) async {
    final db = await database;
    return await db.delete(
      'Cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItemByProductId(int productId) async {
    final db = await database;
    return await db.delete(
      'Cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<int> clearCart() async {
    final db = await database;
    return await db.delete('Cart');
  }

  // Xóa database và tạo lại (dùng khi có lỗi migration)
  Future<void> deleteDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'db_product.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // Đóng database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 