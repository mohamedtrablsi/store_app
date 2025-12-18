import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('مقارنة المنتجات'),
      ),
      body: const Center(
        child: Text(
          'أضف المنتجات للمقارنة بين المواصفات والأسعار',
          style: TextStyle(color: AppColors.textMuted),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
