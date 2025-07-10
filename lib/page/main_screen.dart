import 'package:flutter/material.dart';
import 'package:app_auth/page/auth/login.dart';
import 'package:app_auth/page/home/home_page.dart';
import 'package:app_auth/page/profile/profile_page.dart';
import 'package:app_auth/page/settings/settings_page.dart';
import 'package:app_auth/page/auth/register.dart';
import 'package:app_auth/widget/app_drawer.dart';
import 'package:app_auth/widget/app_bottom_nav.dart';
import 'package:app_auth/page/contact/contact_page.dart';
import 'package:app_auth/page/config/config_page.dart';
import 'package:provider/provider.dart';
import '../model/theme_provider.dart';
import '../model/user_prefs.dart';

import 'package:app_auth/page/category/categorybody.dart';
import 'package:app_auth/page/product/productbody.dart';
import 'package:app_auth/page/cart/cart_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int? _selectedCategoryId; // Lưu categoryId khi chọn
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await UserPrefs.getUser();
    setState(() {
      _userData = userData;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Nếu chuyển sang Product mà chưa chọn category thì bỏ lọc
      if (index == 2 && _selectedCategoryId == null) {
        _selectedCategoryId = null;
      }
    });
  }

  // Map route name to index
  static const Map<String, int> _routeToIndex = {
    'home': 0,
    'category': 1,
    'product': 2,
    'cart': 3,
    'profile': 4,
    'contact': 5,
    'config': 6,
    'settings': 7,
  };

  void _handleNavigation(String route) {
    Navigator.pop(context);
    if (_routeToIndex.containsKey(route)) {
      setState(() {
        _selectedIndex = _routeToIndex[route]!;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _getPageForRoute(route),
        ),
      );
    }
  }

  Widget _getPageForRoute(String route) {
    switch (route) {
      case 'register':
        return const RegisterlPage();
      case 'login':
        return const LoginPage();
      case 'cart':
        return const CartPage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tạo pages trong build method để có thể rebuild khi _selectedCategoryId thay đổi
    final List<Widget> pages = [
      const HomePage(),
      // Category page với callback chọn category
      CategoryBody(
        onCategorySelected: (category) {
          setState(() {
            _selectedCategoryId = category.id;
            _selectedIndex = 2; // Chuyển sang tab Product
          });
        },
      ),
      // Product page, truyền categoryId nếu có
      ProductBody(
        categoryId: _selectedCategoryId,
      ),
      // Cart page
      const CartPage(),
      // Profile page với callback refresh user data
      ProfilePage(
        onUserDataUpdated: () {
          _loadUserData(); // Refresh user data khi có thay đổi
        },
      ),
      const ContactPage(),
      const ConfigPage(),
      const SettingsPage(),
    ];

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 90,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF764ba2), Color(0xFF667eea)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Builder(
                              builder: (context) => InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => Scaffold.of(context).openDrawer(),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.menu, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: const Icon(Icons.shopping_bag, color: Colors.white),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Tuan Anh Shop',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Chào mừng ${_userData?['fullName'] ?? 'bạn'} trở lại!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.notifications_outlined, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Page Content
              SliverFillRemaining(
                child: pages[_selectedIndex],
              ),
            ],
          ),
          drawer: AppDrawer(
            fullName: _userData?['fullName'],
            email: _userData?['email'],
            imageUrl: _userData?['imageUrl'],
            selectedIndex: _selectedIndex,
            onNavigation: _handleNavigation,
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
} 