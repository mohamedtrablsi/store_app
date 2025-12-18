import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('الإعدادات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildItem(
              icon: Icons.dark_mode_outlined,
              title: 'الوضع المظلم',
              subtitle: 'استخدم وضع الجهاز',
            ),
            _buildItem(
              icon: Icons.language_rounded,
              title: 'اللغة',
              subtitle: 'العربية',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textLight),
        title: Text(title, style: const TextStyle(color: AppColors.textLight)),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              )
            : null,
        onTap: () {},
      ),
    );
  }
}
