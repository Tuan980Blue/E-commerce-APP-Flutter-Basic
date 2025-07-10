import 'package:flutter/material.dart';
import 'package:app_auth/page/auth/login.dart';
import 'package:app_auth/page/auth/register.dart';
import 'package:provider/provider.dart';
import '../model/theme_provider.dart';
import '../model/user_prefs.dart';

class AppDrawer extends StatelessWidget {
  final String? fullName;
  final String? email;
  final String? imageUrl;
  final int selectedIndex;
  final Function(String) onNavigation;

  const AppDrawer({
    Key? key,
    this.fullName,
    this.email,
    this.imageUrl,
    required this.selectedIndex,
    required this.onNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeProvider.colorScheme.primary.withOpacity(0.9),
                  Colors.white,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 70, 10, 20),
                  child: Row(
                    children: [
                      // Avatar Column
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 3,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                              ? NetworkImage(imageUrl!)
                              : null,
                          child: imageUrl == null || imageUrl!.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: themeProvider.colorScheme.primary,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // User Info Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName ?? 'Đang tải...',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.colorScheme.primary,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email ?? 'Đang tải email...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black38,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (fullName != null && email != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 12,
                                      color: themeProvider.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Đã đăng nhập',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: themeProvider.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        _buildDrawerItem(
                          icon: Icons.home_rounded,
                          title: 'Home',
                          index: 0,
                          onTap: () => onNavigation('home'),
                          themeProvider: themeProvider,
                        ),
                        _buildDrawerItem(
                          icon: Icons.category_rounded,
                          title: 'Category',
                          index: 1,
                          onTap: () => onNavigation('category'),
                          themeProvider: themeProvider,
                        ),
                        _buildDrawerItem(
                          icon: Icons.inventory_2_rounded,
                          title: 'Product',
                          index: 2,
                          onTap: () => onNavigation('product'),
                          themeProvider: themeProvider,
                        ),
                        _buildDrawerItem(
                          icon: Icons.shopping_cart_rounded,
                          title: 'Cart',
                          index: 3,
                          onTap: () => onNavigation('cart'),
                          themeProvider: themeProvider,
                        ),
                        _buildDrawerItem(
                          icon: Icons.person_rounded,
                          title: 'Profile',
                          index: 4,
                          onTap: () => onNavigation('profile'),
                          themeProvider: themeProvider,
                        ),
                        _buildDrawerItem(
                          icon: Icons.contacts_rounded,
                          title: 'Contact',
                          index: 5,
                          onTap: () => onNavigation('contact'),
                          themeProvider: themeProvider,
                        ),
                        _buildDrawerItem(
                          icon: Icons.build_rounded,
                          title: 'Config',
                          index: 6,
                          onTap: () => onNavigation('config'),
                          themeProvider: themeProvider,
                        ),
                        _buildDrawerItem(
                          icon: Icons.settings_rounded,
                          title: 'Settings',
                          index: 7,
                          onTap: () => onNavigation('settings'),
                          themeProvider: themeProvider,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Divider(height: 1),
                        ),
                        _buildDrawerItem(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          index: -1,
                          isLogout: true,
                          onTap: () async {
                            await _showLogoutDialog(context);
                          },
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              const SizedBox(width: 8),
              const Text('Đăng xuất'),
            ],
          ),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    await UserPrefs.logout();
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
    bool isLogout = false,
  }) {
    final bool isSelected = index == selectedIndex;
    final Color primaryColor = themeProvider.colorScheme.primary;
    final Color textColor = isLogout ? Colors.red : (isSelected ? primaryColor : Colors.black87);
    final Color iconColor = isLogout ? Colors.red : (isSelected ? primaryColor : Colors.black54);
    final Color bgColor = isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 5,
                height: 20,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
} 