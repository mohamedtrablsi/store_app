import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String title;
  final int price;
  final int qty;
  final String image;

  OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.qty,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'title': title,
    'price': price,
    'qty': qty,
    'image': image,
  };

  factory OrderItem.fromMap(Map<String, dynamic> data) => OrderItem(
    productId: (data['productId'] ?? '').toString(),
    title: (data['title'] ?? '').toString(),
    price: (data['price'] as num?)?.toInt() ?? 0,
    qty: (data['qty'] as num?)?.toInt() ?? 1,
    image: (data['image'] ?? '').toString(),
  );
}

class OrderModel {
  final String id;
  final String userId;
  final String paymentMethod; // cash | card
  final String status; // pending | processing | delivered | cancelled
  final int total; // ✅ int
  final List<OrderItem> items;
  final DateTime? createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.paymentMethod,
    required this.status,
    required this.total,
    required this.items,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'paymentMethod': paymentMethod,
    'status': status,
    'total': total,
    'items': items.map((e) => e.toMap()).toList(),
    'createdAt': createdAt == null
        ? FieldValue.serverTimestamp()
        : Timestamp.fromDate(createdAt!),
  };

  factory OrderModel.fromDoc(String id, Map<String, dynamic> data) {
    final ts = data['createdAt'];
    DateTime? dt;
    if (ts is Timestamp) dt = ts.toDate();

    final rawItems = (data['items'] as List?) ?? [];
    final items = rawItems
        .whereType<Map>()
        .map((m) => OrderItem.fromMap(Map<String, dynamic>.from(m)))
        .toList();

    return OrderModel(
      id: id,
      userId: (data['userId'] ?? '').toString(),
      paymentMethod: (data['paymentMethod'] ?? 'cash').toString(),
      status: (data['status'] ?? 'pending').toString(),
      total: (data['total'] ?? 0) is int
          ? data['total'] as int
          : (data['total'] as num).toInt(),
      items: items,
      createdAt: dt,
    );
  }
}
