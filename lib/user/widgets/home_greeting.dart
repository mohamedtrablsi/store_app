import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class HomeGreeting extends StatelessWidget {
  final String userName;
  const HomeGreeting({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مساء الخير $userName',
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'استمتع بأحدث المنتجات مع الريادة ✨',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
