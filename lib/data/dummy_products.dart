import 'package:cloud_firestore/cloud_firestore.dart';

/// موديل بسيط للمنتج
class ProductData {
  final String id;
  final String title;
  final String brand;
  final double price;
  final String imagePath;
  final String category;
  final int stock;

  const ProductData({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.stock,
  });

  factory ProductData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ProductData(
      id: doc.id,
      title: data['title'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] as num).toDouble(),
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? '',
      stock: (data['stock'] as num?)?.toInt() ?? 0,
    );
  }
}
