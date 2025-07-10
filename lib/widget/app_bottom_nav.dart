import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/theme_provider.dart';
import '../data/provider/cartprovider.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AppBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    themeProvider: themeProvider,
                  ),
                  _buildNavItem(
                    icon: Icons.category_rounded,
                    label: 'Category',
                    index: 1,
                    themeProvider: themeProvider,
                  ),
                  _buildNavItem(
                    icon: Icons.inventory_2_rounded,
                    label: 'Product',
                    index: 2,
                    themeProvider: themeProvider,
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return _buildNavItem(
                        icon: Icons.shopping_cart_rounded,
                        label: 'Cart',
                        index: 3,
                        themeProvider: themeProvider,
                        badge: cartProvider.itemCount > 0 ? cartProvider.itemCount.toString() : null,
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 4,
                    themeProvider: themeProvider,
                  ),
                  _buildNavItem(
                    icon: Icons.contact_phone_rounded,
                    label: 'Contact',
                    index: 5,
                    themeProvider: themeProvider,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required ThemeProvider themeProvider,
    String? badge,
  }) {
    final bool isSelected = index == selectedIndex;
    final Color primaryColor = themeProvider.colorScheme.primary;
    
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? primaryColor : Colors.grey,
                  size: 24,
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
            if (badge != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 