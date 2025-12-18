import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../theme/app_colors.dart';

class CartPage extends StatelessWidget {
  final List<ProductModel> products;
  final Map<String, int> quantities;
  final double total;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.products,
    required this.quantities,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_cart_outlined, color: Colors.white54, size: 56),
            SizedBox(height: 10),
            Text(
              'السلة فارغة',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'ابدأ بإضافة منتجات للسلة 👌',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // عنوان بسيط
            Row(
              children: const [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white70,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'سلة المشتريات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final p = products[index];
                  final q = quantities[p.id] ?? 0;

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderSoft),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/${p.image}',
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 54,
                            height: 54,
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      title: Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${p.price} د.ل  ×  $q',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'المجموع',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(p.price * q).toStringAsFixed(0)} د.ل',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ملخص + زر
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'الإجمالي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${total.toStringAsFixed(0)} د.ل',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onCheckout,
                      child: const Text(
                        'إتمام الطلب',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
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
