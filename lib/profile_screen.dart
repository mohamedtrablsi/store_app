import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('بيانات الحساب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ستحتاج إلى هذه البيانات لإتمام أي عملية داخل التطبيق',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildItem(context, 'المعلومات الشخصية'),
            _buildItem(context, 'رقم الهاتف'),
            _buildItem(context, 'عناوين'),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary2,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.edit, color: Colors.white, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: AppColors.textLight)),
        onTap: () {},
      ),
    );
  }
}
