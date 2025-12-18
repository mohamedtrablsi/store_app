import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class HomeBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.scaffoldDark,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'مفضلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'استكشاف',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'البحث',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'السلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'الرئيسية',
        ),
      ],
    );
  }
}
