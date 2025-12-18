import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import 'add_edit_product_screen.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ProductService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إدارة المنتجات')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditProductScreen()),
          ),
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<List<ProductModel>>(
          stream: service.streamProducts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            if (items.isEmpty)
              return const Center(child: Text('لا توجد منتجات'));

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final p = items[i];
                return Card(
                  child: ListTile(
                    title: Text(p.title),
                    subtitle: Text('Stock: ${p.stock} | Price: ${p.price}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditProductScreen(product: p),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async => service.deleteProduct(p.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
