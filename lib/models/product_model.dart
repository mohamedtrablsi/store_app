class ProductModel {
  final String id;
  final String title;
  final String brand;
  final String category;
  final String image; // اسم الصورة داخل assets/images/
  final int price;
  final int stock;

  ProductModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.image,
    required this.price,
    required this.stock,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      title: (data['title'] ?? '').toString(),
      brand: (data['brand'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      price: (data['price'] is int)
          ? data['price']
          : (data['price'] as num?)?.toInt() ?? 0,
      stock: (data['stock'] is int)
          ? data['stock']
          : (data['stock'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'brand': brand,
      'category': category,
      'image': image,
      'price': price,
      'stock': stock,
    };
  }
}
