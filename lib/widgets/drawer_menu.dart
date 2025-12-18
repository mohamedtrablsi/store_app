import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';

import '../about_app_screen.dart';
import '../compare_screen.dart';
import '../custom_order_screen.dart';
import '../faq_screen.dart';
import '../maintenance_screen.dart';
import '../notifications_screen.dart';
import '../privacy_screen.dart';
import '../profile_screen.dart';
import '../settings_screen.dart';

// ✅ شاشة لوحة التحكم (بنضيفها بعد تحت)
import '../admin/admin_dashboard.dart';

class DrawerMenu extends StatelessWidget {
  final String userName;
  final bool isAdmin;

  final VoidCallback onOrdersTap;

  const DrawerMenu({
    super.key,
    required this.userName,
    required this.onOrdersTap,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 14),

              _buildMenuItem(
                icon: Icons.receipt_long,
                title: 'طلباتي',
                onTap: () {
                  Navigator.pop(context);
                  onOrdersTap();
                },
              ),

              // ✅ زر الأدمن يظهر فقط لو role=admin
              if (isAdmin)
                _buildMenuItem(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'لوحة التحكم',
                  onTap: () => _open(context, const AdminDashboard()),
                ),

              _buildDivider(),

              _buildMenuItem(
                icon: Icons.add_box_outlined,
                title: 'طلب مخصص',
                onTap: () => _open(context, const CustomOrderScreen()),
              ),
              _buildMenuItem(
                icon: Icons.compare_arrows_rounded,
                title: 'مقارنة المنتجات',
                onTap: () => _open(context, const CompareScreen()),
              ),
              _buildMenuItem(
                icon: Icons.build_outlined,
                title: 'الصيانة',
                onTap: () => _open(context, const MaintenanceScreen()),
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'الأسئلة الشائعة',
                onTap: () => _open(context, const FAQScreen()),
              ),
              _buildMenuItem(
                icon: Icons.notifications_active_outlined,
                title: 'الإشعارات',
                onTap: () => _open(context, const NotificationsScreen()),
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'حول التطبيق',
                onTap: () => _open(context, const AboutAppScreen()),
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسات الخصوصية',
                onTap: () => _open(context, const PrivacyScreen()),
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'الإعدادات',
                onTap: () => _open(context, const SettingsScreen()),
              ),

              const Spacer(),

              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'بيانات الحساب',
                onTap: () => _open(context, const ProfileScreen()),
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'تسجيل الخروج',
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                color: Colors.white,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(height: 1, color: Colors.white.withOpacity(0.18)),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildHeader(BuildContext context) {
    final letter = userName.trim().isNotEmpty ? userName.trim()[0] : 'N';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.18),
            child: Text(
              letter.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.isEmpty ? 'مستخدم' : userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isAdmin ? "حساب أدمن" : "مرحبا بك",
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
