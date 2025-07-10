import 'package:app_auth/page/main_screen.dart';
import 'package:flutter/material.dart';
import 'model/user_prefs.dart';
import 'model/theme_provider.dart';
import 'page/welcome_page.dart';
import 'package:provider/provider.dart';
import 'data/provider/categoryprovider.dart';
import 'data/provider/productprovider.dart';
import 'data/provider/cartprovider.dart';
import 'data/database/database_helper.dart';
import 'package:flutter/foundation.dart';

void main() async {
  // Đảm bảo Flutter binding được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo database
  final dbHelper = DatabaseHelper();
  try {
    await dbHelper.database;
  } catch (e) {
    // Nếu có lỗi, xóa database cũ và tạo lại
    await dbHelper.deleteDatabase();
    await dbHelper.database;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Tuan Anh Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: themeProvider.colorScheme,
            useMaterial3: true,
          ),
          home: FutureBuilder<bool>(
            future: UserPrefs.isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.data == true) {
                return const MainScreen();
              } else {
                return const WelcomePage();
              }
            },
          ),
        );
      },
    );
  }
}
