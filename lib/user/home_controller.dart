import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import '../models/order_model.dart';

class HomeController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Set<String> favoriteIds = {};
  final Map<String, int> cartQuantities = {};
  final Map<String, int> productStocks = {};

  bool loading = true;

  String userName = 'مستخدم';
  String userRole = 'user'; // user/admin

  User? get user => FirebaseAuth.instance.currentUser;
  bool get isAdmin => userRole == 'admin';

  StreamSubscription? _stocksSub;
  StreamSubscription? _userSub;

  Future<void> init() async {
    loading = true;
    notifyListeners();

    await _listenUserProfile();
    await _loadUserData();
    _listenStocks();

    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stocksSub?.cancel();
    _userSub?.cancel();
    super.dispose();
  }

  // لو تستعملها في HomeScreen: controller.disposeController();
  void disposeController() {
    _stocksSub?.cancel();
    _userSub?.cancel();
  }

  Future<void> _listenUserProfile() async {
    final u = user;
    if (u == null) return;

    _userSub?.cancel();
    _userSub = _db.collection('users').doc(u.uid).snapshots().listen((doc) {
      final data = doc.data() ?? {};

      final name = (data['name'] as String?)?.trim();
      userName = (name != null && name.isNotEmpty)
          ? name
          : (u.displayName?.trim().isNotEmpty == true
                ? u.displayName!
                : (u.email ?? 'مستخدم'));

      userRole = (data['role'] as String?) ?? 'user';
      notifyListeners();
    });
  }

  void _listenStocks() {
    _stocksSub?.cancel();
    _stocksSub = _db.collection('products').snapshots().listen((snap) {
      productStocks.clear();
      for (final doc in snap.docs) {
        final data = doc.data();
        productStocks[doc.id] = (data['stock'] as num?)?.toInt() ?? 0;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData() async {
    final u = user;
    if (u == null) return;

    // favorites
    final favSnap = await _db
        .collection('users')
        .doc(u.uid)
        .collection('favorites')
        .get();

    favoriteIds
      ..clear()
      ..addAll(favSnap.docs.map((d) => d.id));

    // cart
    final cartSnap = await _db
        .collection('users')
        .doc(u.uid)
        .collection('cart')
        .get();

    cartQuantities.clear();
    for (final doc in cartSnap.docs) {
      final q = (doc.data()['quantity'] as num?)?.toInt() ?? 0;
      if (q > 0) cartQuantities[doc.id] = q;
    }

    notifyListeners();
  }

  // ================== Helpers ==================

  bool isFavorite(String productId) => favoriteIds.contains(productId);
  int quantityOf(String productId) => cartQuantities[productId] ?? 0;
  int? stockOf(String productId) => productStocks[productId];

  List<ProductModel> cartProducts(List<ProductModel> allProducts) =>
      allProducts.where((p) => (cartQuantities[p.id] ?? 0) > 0).toList();

  List<ProductModel> favoriteProducts(List<ProductModel> allProducts) =>
      allProducts.where((p) => favoriteIds.contains(p.id)).toList();

  int totalCartCount() {
    int sum = 0;
    for (final v in cartQuantities.values) {
      sum += v;
    }
    return sum;
  }

  int cartTotalInt(List<ProductModel> allProducts) {
    final products = cartProducts(allProducts);
    int total = 0;
    for (final p in products) {
      final qty = cartQuantities[p.id] ?? 0;
      total += (p.price * qty);
    }
    return total;
  }

  // ================== Favorites ==================

  Future<void> toggleFavorite(ProductModel product) async {
    final u = user;
    if (u == null) return;

    final ref = _db
        .collection('users')
        .doc(u.uid)
        .collection('favorites')
        .doc(product.id);

    final willBeFav = !favoriteIds.contains(product.id);

    if (willBeFav) {
      favoriteIds.add(product.id);
      notifyListeners();
      await ref.set({
        'productId': product.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      favoriteIds.remove(product.id);
      notifyListeners();
      await ref.delete();
    }
  }

  // ================== Cart ==================

  Future<void> addOne(ProductModel product, BuildContext context) async {
    final u = user;
    if (u == null) return;

    final stock = stockOf(product.id);
    final inCart = quantityOf(product.id);

    if (stock != null && (stock <= 0 || inCart >= stock)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الكمية المتاحة من هذا المنتج نفذت')),
        );
      }
      return;
    }

    final newQty = inCart + 1;
    cartQuantities[product.id] = newQty;
    notifyListeners();

    final cartRef = _db
        .collection('users')
        .doc(u.uid)
        .collection('cart')
        .doc(product.id);

    await cartRef.set({
      'productId': product.id,
      'quantity': newQty,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeOne(ProductModel product) async {
    final u = user;
    if (u == null) return;

    final current = quantityOf(product.id);
    if (current <= 0) return;

    final newQty = current - 1;

    if (newQty == 0) {
      cartQuantities.remove(product.id);
    } else {
      cartQuantities[product.id] = newQty;
    }
    notifyListeners();

    final cartRef = _db
        .collection('users')
        .doc(u.uid)
        .collection('cart')
        .doc(product.id);

    if (newQty == 0) {
      await cartRef.delete();
    } else {
      await cartRef.set({
        'productId': product.id,
        'quantity': newQty,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // ================== Payment Picker ==================

  Future<String?> pickPaymentMethod(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF151515),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'اختر طريقة الدفع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(
                    Icons.payments_outlined,
                    color: Colors.greenAccent,
                  ),
                  title: const Text(
                    'كاش عند الاستلام',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'cash'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.credit_card,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    'بطاقة مصرفية',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'card'),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================== Success Dialog ==================

  void showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF151515),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.greenAccent),
                SizedBox(width: 10),
                Text('تم استلام طلبك ✅', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: const Text(
              'شكراً لك! طلبك قيد المعالجة.\n'
              'تقدر تتابع حالة الطلب من صفحة "طلباتي".',
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('متابعة التسوق'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('تمام'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================== Checkout ==================

  Future<bool> checkout({
    required BuildContext context,
    required List<ProductModel> allProducts,
    required String paymentMethod, // cash / card
  }) async {
    final u = user;
    if (u == null) return false;

    final products = cartProducts(allProducts);
    if (products.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('السلة فارغة')));
      }
      return false;
    }

    final total = cartTotalInt(allProducts);

    try {
      await _db.runTransaction((tx) async {
        // ================== 1) READS ==================
        final Map<String, int> currentStocks = {};

        for (final p in products) {
          final qty = cartQuantities[p.id] ?? 0;
          if (qty <= 0) continue;

          final productRef = _db.collection('products').doc(p.id);
          final snap = await tx.get(productRef);

          final data = snap.data() as Map<String, dynamic>? ?? {};
          final stock = (data['stock'] as num?)?.toInt() ?? 0;

          if (stock < qty) {
            throw Exception(
              'الكمية المطلوبة من "${p.title}" أكبر من المتاح ($stock)',
            );
          }

          currentStocks[p.id] = stock;
        }

        // ================== 2) WRITES ==================
        for (final p in products) {
          final qty = cartQuantities[p.id] ?? 0;
          if (qty <= 0) continue;

          final productRef = _db.collection('products').doc(p.id);
          final newStock = currentStocks[p.id]! - qty;

          tx.update(productRef, {'stock': newStock});
          productStocks[p.id] = newStock;
        }

        final orderId = _db.collection('orders').doc().id;

        final items = products.map((p) {
          return OrderItem(
            productId: p.id,
            title: p.title,
            price: p.price,
            qty: cartQuantities[p.id] ?? 0,
            image: p.image,
          );
        }).toList();

        final order = OrderModel(
          id: orderId,
          userId: u.uid,
          paymentMethod: paymentMethod,
          status: 'pending',
          total: total,
          items: items,
          createdAt: null,
        );

        tx.set(_db.collection('orders').doc(orderId), order.toMap());
        tx.set(
          _db.collection('users').doc(u.uid).collection('orders').doc(orderId),
          order.toMap(),
        );
      });

      // ================== 3) DELETE CART (OUTSIDE TX) ==================
      final cartCol = _db.collection('users').doc(u.uid).collection('cart');
      final cartSnap = await cartCol.get();

      for (final d in cartSnap.docs) {
        await d.reference.delete();
      }

      cartQuantities.clear();
      notifyListeners();

      if (context.mounted) {
        showOrderSuccessDialog(context);
      }

      return true;
    } catch (e) {
      debugPrint('Checkout error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إتمام الطلب: ${e.toString()}')),
        );
      }
      return false;
    }
  }
}
