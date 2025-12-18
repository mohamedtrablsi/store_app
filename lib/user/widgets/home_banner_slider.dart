import 'package:flutter/material.dart';

class HomeBannerSlider extends StatelessWidget {
  final PageController controller;
  const HomeBannerSlider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: PageView(
        controller: controller,
        children: [
          _bannerItem(
            gradientColors: const [Color(0xFFFF5B7A), Color(0xFFFF8C42)],
            title: 'أقوى عروض الشاشات',
            subtitle: 'خصومات حصرية داخل التطبيق',
          ),
          _bannerItem(
            gradientColors: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
            title: 'أجهزة الألعاب',
            subtitle: 'PS5 و XBOX بأسعار مميزة',
          ),
          _bannerItem(
            gradientColors: const [Color(0xFF7F00FF), Color(0xFFE100FF)],
            title: 'هواتف ذكية',
            subtitle: 'أحدث الإصدارات متوفرة الآن',
          ),
        ],
      ),
    );
  }

  Widget _bannerItem({
    required List<Color> gradientColors,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
