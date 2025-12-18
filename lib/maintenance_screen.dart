import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('الصيانة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.build_rounded,
                      color: AppColors.primary,
                      size: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'يسعدنا تقديم خدمات صيانة الإلكترونيات بكفاءة عالية واهتمام\nبأدق التفاصيل.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {},
                child: const Text('هيا نبدأ'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض طلبات الصيانة السابقة',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
