import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  Future<void> createOrder({
    required String userId,
    required String paymentMethod,
    required int total,
    required List<OrderItem> items,
  }) async {
    await _db.collection('orders').add({
      'userId': userId,
      'paymentMethod': paymentMethod,
      'status': 'pending',
      'total': total,
      'items': items.map((e) => e.toMap()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({'status': status});
  }
}
