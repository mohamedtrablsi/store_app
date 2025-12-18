import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/product_card.dart';

class HomeProductSection extends StatelessWidget {
  final String title;
  final String categoryId;

  final List<ProductModel> allProducts;
  final Set<String> favoriteIds;
  final Map<String, int> quantities;

  final Future<void> Function(ProductModel p) onToggleFavorite;
  final Future<void> Function(ProductModel p) onIncrement;
  final Future<void> Function(ProductModel p) onDecrement;

  const HomeProductSection({
    super.key,
    required this.title,
    required this.categoryId,
    required this.allProducts,
    required this.favoriteIds,
    required this.quantities,
    required this.onToggleFavorite,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final products = allProducts
        .where((p) => p.category == categoryId)
        .toList();

    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              const Icon(Icons.category_outlined, color: AppColors.textLight),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 18),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              final isFav = favoriteIds.contains(p.id);
              final qty = quantities[p.id] ?? 0;

              final outOfStock = p.stock <= 0; // ✅ من نفس المنتج

              return ProductCard(
                title: p.title,
                brand: p.brand,
                price: p.price.toString(),
                image: p.image,
                isFavorite: isFav,
                quantity: qty,
                outOfStock: outOfStock,
                onTap: () {},
                onToggleFavorite: () => onToggleFavorite(p),
                onIncrement: () => onIncrement(p),
                onDecrement: () => onDecrement(p),
                onCartTap: () => onIncrement(p),
              );
            },
          ),
        ),
      ],
    );
  }
}
