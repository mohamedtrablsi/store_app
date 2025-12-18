import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../theme/app_colors.dart';

class FavoritesPage extends StatelessWidget {
  final List<ProductModel> products;
  const FavoritesPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد منتجات مفضلة بعد',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          color: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/${p.image}',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            title: Text(p.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '${p.price} د.ل',
              style: const TextStyle(color: Colors.greenAccent),
            ),
          ),
        );
      },
    );
  }
}
