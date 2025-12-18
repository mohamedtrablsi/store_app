import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('المفضلة'),
      ),
      body: const Center(
        child: Text(
          'لا توجد منتجات مفضلة بعد',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
