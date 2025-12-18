// lib/widgets/section_title.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String emoji;
  final String title;

  const SectionTitle({super.key, required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
