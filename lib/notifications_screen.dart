import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('الإشعارات'),
      ),
      body: const Center(
        child: Text(
          'لا توجد إشعارات حالياً',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
