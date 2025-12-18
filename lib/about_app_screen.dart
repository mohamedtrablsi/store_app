import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('حول التطبيق'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: const [
            SizedBox(height: 40),
            // حط لوجو متجر نزار هنا
            Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.primary,
              size: 96,
            ),
            SizedBox(height: 16),
            Text(
              'متجر نزار للإلكترونيات',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'الآن يمكنك الغوص في عالم الإلكترونيات لتصفح المنتجات\nوالحصول على عروض خاصة بأسعار مميزة.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              'تم تطويره بواسطة نزار محمد ميلاد',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
