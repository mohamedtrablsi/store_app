import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onOpenDrawer;

  const HomeAppBar({super.key, required this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldDark,
      elevation: 0,
      title: const Text(
        'متجر نزار للإلكترونيات',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.notifications_none_rounded),
        onPressed: () {},
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: onOpenDrawer,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
