import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('سياسات الخصوصية'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'نص سياسات الخصوصية يوضع هنا (يمكنك إضافته لاحقاً)\n'
          'حول كيفية التعامل مع بيانات المستخدم وحقوقه داخل التطبيق.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ),
    );
  }
}
