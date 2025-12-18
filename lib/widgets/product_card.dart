import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String brand;
  final String price;
  final String image;
  final bool isFavorite;
  final int quantity;
  final bool outOfStock;

  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onCartTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.brand,
    required this.price,
    required this.image,
    required this.isFavorite,
    required this.quantity,
    required this.outOfStock,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSoft),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/$image",
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                  if (outOfStock)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'نفاذ الكمية',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  brand,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "$price د.ل",
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: outOfStock ? () {} : onCartTap,
                  child: Opacity(
                    opacity: outOfStock ? 0.4 : 1,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: outOfStock ? 0.4 : 1,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: outOfStock ? () {} : onDecrement,
                        child: _circle(Icons.remove),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: outOfStock ? () {} : onIncrement,
                        child: _circle(Icons.add),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onToggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _circle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
