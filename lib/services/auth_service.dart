import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _db = FirebaseFirestore.instance;

  Future<bool> isAdmin(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return false;
    final role = (doc.data()?['role'] ?? 'user').toString();
    return role == 'admin';
  }

  Future<void> ensureUserDoc({
    required String uid,
    required String email,
    String name = '',
  }) async {
    final ref = _db.collection('users').doc(uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'email': email,
        'name': name,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
