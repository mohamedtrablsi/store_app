import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class CustomOrderScreen extends StatelessWidget {
  const CustomOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('طلب مخصص'),
      ),
      body: const Center(
        child: Text(
          'هنا نموذج لطلب مواصفات خاصة (نجهزوها لاحقًا)',
          style: TextStyle(color: AppColors.textMuted),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
