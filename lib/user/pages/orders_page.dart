import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_colors.dart';
import '../../services/order_service.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldDark,
        body: Center(
          child: Text(
            'الرجاء تسجيل الدخول',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final service = OrderService();

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        title: const Text('طلباتي'),
      ),
      body: StreamBuilder(
        stream: service.streamUserOrders(user.uid),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = (snap.data!).docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد طلبات بعد',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i].data();
              final total = (d['total'] ?? 0).toString();
              final pay = (d['paymentMethod'] ?? 'cash').toString();
              final status = (d['status'] ?? 'pending').toString();

              return Card(
                color: AppColors.cardDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(
                    'الإجمالي: $total د.ل',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'الدفع: ${pay == 'cash' ? 'كاش' : 'بطاقة'} • الحالة: $status',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
