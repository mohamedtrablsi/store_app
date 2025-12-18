import 'package:flutter/material.dart';
import 'package:store_app/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primary : AppColors.cardDark;
    final fg = selected ? Colors.white : AppColors.textMuted;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.only(right: 10, bottom: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
