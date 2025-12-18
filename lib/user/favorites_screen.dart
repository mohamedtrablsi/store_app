import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import 'home_controller.dart';
import 'pages/favorites_page.dart';

class FavoritesScreen extends StatelessWidget {
  final HomeController controller;
  const FavoritesScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final service = ProductService();

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('المفضلة'),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: service.streamProducts(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allProducts = snap.data!;
          final favProducts = controller.favoriteProducts(allProducts);

          return FavoritesPage(products: favProducts);
        },
      ),
    );
  }
}
