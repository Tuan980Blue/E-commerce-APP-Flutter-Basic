import 'package:flutter/material.dart';
import 'package:app_auth/page/auth/login.dart';
import '../../model/user_prefs.dart';
import '../../getdata/product_data.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Thông báo'),
          trailing: Switch(
            value: true,
            onChanged: (bool value) {},
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Chế độ tối'),
          trailing: Switch(
            value: false,
            onChanged: (bool value) {},
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Ngôn ngữ'),
          trailing: const Text('Tiếng Việt'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.data_usage),
          title: const Text('Load dữ liệu mẫu'),
          subtitle: const Text('Tải dữ liệu từ JSON'),
          onTap: () async {
            try {
              await ProductData.loadAllDataFromJson();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã load dữ liệu mẫu thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          onTap: () async {
            await UserPrefs.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
} 