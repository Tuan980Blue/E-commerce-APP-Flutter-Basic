import 'package:flutter/material.dart';
import '../../model/user_prefs.dart';
import '../../model/theme_manager.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onUserDataUpdated;
  
  const ProfilePage({Key? key, this.onUserDataUpdated}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  String currentTheme = 'blue';

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadTheme();
  }

  void _loadUser() async {
    final u = await UserPrefs.getUser();
    setState(() {
      user = u;
    });
  }

  void _loadTheme() async {
    final theme = await ThemeManager.getCurrentTheme();
    setState(() {
      currentTheme = theme;
    });
  }

  void refreshUserData() async {
    _loadUser();
    // Gọi callback để thông báo cho parent widget
    widget.onUserDataUpdated?.call();
  }

  @override
  Widget build(BuildContext context) {
    final fullName = user?['fullName'] ?? 'Chưa cập nhật tên';
    final email = user?['email'] ?? 'Chưa cập nhật email';
    final imageUrl = user?['imageUrl'] ?? '';
    final gender = user?['gender'] ?? 'Chưa cập nhật';
    final favorites = (user?['favorites'] as List?)?.cast<String>() ?? [];

    // Lấy ColorScheme từ theme hiện tại
    final colorScheme = ThemeManager.getColorScheme(currentTheme);

    return Scaffold(
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header với background gradient và avatar
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Icon(
                            Icons.pattern,
                            size: 200,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        // Profile content
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: colorScheme.primary,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                fullName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Information Cards
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Personal Information Card
                        _buildInfoCard(
                          context,
                          'Thông tin cá nhân',
                          Icons.person_outline,
                          colorScheme,
                          [
                            _buildInfoRow(Icons.email_outlined, 'Email', email),
                            _buildInfoRow(Icons.person_outline, 'Giới tính', gender),
                            if (favorites.isNotEmpty)
                              _buildInfoRow(
                                Icons.favorite_outline,
                                'Sở thích',
                                favorites.join(', '),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Preferences Card
                        if (favorites.isNotEmpty)
                          _buildInfoCard(
                            context,
                            'Sở thích',
                            Icons.favorite_outline,
                            colorScheme,
                            [
                              _buildChipRow(favorites, colorScheme),
                            ],
                          ),
                        const SizedBox(height: 16),

                        // Account Settings Card
                        _buildInfoCard(
                          context,
                          'Cài đặt tài khoản',
                          Icons.settings_outlined,
                          colorScheme,
                          [
                            _buildSettingRow(
                              context,
                              'Chỉnh sửa thông tin',
                              Icons.edit_outlined,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tính năng đang được phát triển'),
                                  ),
                                );
                              },
                            ),
                            _buildSettingRow(
                              context,
                              'Đổi mật khẩu',
                              Icons.lock_outline,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tính năng đang được phát triển'),
                                  ),
                                );
                              },
                            ),
                            _buildSettingRow(
                              context,
                              'Cài đặt thông báo',
                              Icons.notifications_outlined,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tính năng đang được phát triển'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData icon, ColorScheme colorScheme, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipRow(List<String> labels, ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels
          .map((label) => Chip(
                label: Text(label),
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSettingRow(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
} 