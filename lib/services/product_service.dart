import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;

  Stream<List<ProductModel>> streamProducts() {
    return _db.collection('products').snapshots().map((s) {
      return s.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList();
    });
  }

  Future<void> addProduct(ProductModel p) async {
    await _db.collection('products').add({
      ...p.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProduct(ProductModel p) async {
    await _db.collection('products').doc(p.id).update(p.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }
}
