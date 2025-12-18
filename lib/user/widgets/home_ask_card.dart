import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class HomeAskCard extends StatelessWidget {
  const HomeAskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.cardDark,
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary2],
                ),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'اسألني أي شيء، أنا هنا لمساعدتك',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
