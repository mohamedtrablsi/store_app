import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_colors.dart';
import 'admin_products_screen.dart';
import 'admin_orders_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل تبي تسجّل خروج من حساب الأدمن؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('خروج'),
            ),
          ],
        ),
      ),
    );

    if (ok == true) {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;

      // ✅ الأفضل تمشي للوغين (عدّل '/login' حسب مشروعك)
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldDark,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldDark,
          elevation: 0,
          centerTitle: true,
          title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ).createShader(bounds),
            child: const Text(
              'لوحة تحكم الأدمن',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _confirmLogout(context),
              tooltip: 'تسجيل خروج',
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _AdminHeaderCard(),
            const SizedBox(height: 14),
            const _QuickStatsRow(),
            const SizedBox(height: 18),
            const Text(
              'الإدارة السريعة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            _ActionCard(
              icon: Icons.inventory_2_outlined,
              title: 'إدارة المنتجات',
              subtitle: 'إضافة / تعديل / حذف المنتجات والمخزون',
              tag: 'Products',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.receipt_long,
              title: 'إدارة الطلبات',
              subtitle: 'متابعة الطلبات وتغيير الحالة والتسليم',
              tag: 'Orders',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb_outline, color: Colors.white70),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'نصيحة: خلي role في Firestore تكون "admin" للأدمن باش يطلع زر لوحة التحكم.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminHeaderCard extends StatelessWidget {
  const _AdminHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Text(
                  'مرحباً بك 👋',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  'تحكّم في المتجر بسهولة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'إدارة المنتجات والطلبات من مكان واحد',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            title: 'الطلبات',
            value: '--',
            icon: Icons.shopping_bag_outlined,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'المنتجات',
            value: '--',
            icon: Icons.inventory_2_outlined,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'قيد المعالجة',
            value: '--',
            icon: Icons.timelapse_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ شيلنا height الثابت اللي يسبب overflow
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ مهم
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 10),

          // ✅ يخلي الرقم ما يكبرش زيادة ويسبب overflow
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
