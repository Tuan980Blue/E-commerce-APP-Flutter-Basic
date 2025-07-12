# 🛒 Flutter E-Commerce App

Ứng dụng bán hàng thương mại điện tử được phát triển bằng **Flutter**, sử dụng **SQLite** cho việc lưu trữ dữ liệu cục bộ.

## 🚀 Tính năng chính

- Hiển thị danh sách sản phẩm
- Thêm sản phẩm vào giỏ hàng
- Xem giỏ hàng và xóa sản phẩm
- Quản lý đơn hàng cục bộ
- Tìm kiếm sản phẩm
- Giao diện hiện đại, responsive
## 🧱 Công nghệ sử dụng

- **Flutter**: SDK phát triển ứng dụng đa nền tảng
- **Dart**: Ngôn ngữ lập trình chính
- **SQLite**: Cơ sở dữ liệu cục bộ để lưu trữ sản phẩm, giỏ hàng,...
- **Provider / Riverpod (tuỳ chọn)**: Quản lý trạng thái
- **Sqflite**: Thư viện SQLite cho Flutter

## 📦 Cấu trúc thư mục

lib/
├── models/ # Định nghĩa các model như Product, CartItem,...
├── screens/ # Các màn hình chính: Home, Product Detail, Cart,...
├── widgets/ # Các widget tái sử dụng
├── db/ # Xử lý SQLite: DatabaseHelper,...
├── providers/ # (tuỳ chọn) State management
└── main.dart # Điểm khởi đầu của ứng dụng

r
Copy
Edit

## 💾 SQLite - Quản lý dữ liệu

Ứng dụng sử dụng SQLite để:

- Lưu trữ danh sách sản phẩm (có thể giả lập)
- Lưu giỏ hàng cục bộ
- Quản lý đơn hàng nếu cần

```dart
final db = await database;
await db.insert('cart', cartItem.toMap());
🔧 Cài đặt
Clone repository:

bash
Copy
Edit
git clone https://github.com/yourusername/flutter_ecommerce_app.git
cd flutter_ecommerce_app
Cài đặt dependencies:

bash
Copy
Edit
flutter pub get
Chạy ứng dụng:

bash
Copy
Edit
flutter run
📸 Screenshot
Trang chủ	Chi tiết sản phẩm	Giỏ hàng

📝 Ghi chú
Ứng dụng sử dụng SQLite nên dữ liệu sẽ bị reset khi app bị gỡ cài đặt.

Đây là bản mẫu đơn giản, có thể mở rộng thêm tính năng như đăng nhập, thanh toán, API,...

👨‍💻 Tác giả
Tên bạn – yourgithub

📃 Giấy phép
Dự án này sử dụng giấy phép MIT. Xem LICENSE để biết thêm chi tiết.

r
Copy
Edit
