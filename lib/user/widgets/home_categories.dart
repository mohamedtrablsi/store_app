import 'package:flutter/material.dart';
import '../../widgets/category_chip.dart';

class HomeCategories extends StatelessWidget {
  final int selectedCategory;
  final ValueChanged<int> onTap;

  const HomeCategories({
    super.key,
    required this.selectedCategory,
    required this.onTap,
  });

  static const _cats = [
    ('شاشات', Icons.tv),
    ('هواتف ذكية', Icons.smartphone),
    ('أجهزة ألعاب', Icons.sports_esports),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: _cats.length,
        itemBuilder: (context, index) {
          final item = _cats[index];
          return CategoryChip(
            label: item.$1,
            icon: item.$2,
            selected: selectedCategory == index,
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}
