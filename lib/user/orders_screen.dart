import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/order_service.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final OrderService _orderService = OrderService();

  Color _statusColor(String s) {
    switch (s) {
      case 'pending':
        return Colors.orangeAccent;
      case 'processing':
        return Colors.lightBlueAccent;
      case 'delivered':
        return Colors.greenAccent;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.white70;
    }
  }

  String _statusText(String s) {
    switch (s) {
      case 'pending':
        return 'قيد الانتظار';
      case 'processing':
        return 'قيد المعالجة';
      case 'delivered':
        return 'تم التسليم';
      case 'cancelled':
        return 'ملغي';
      default:
        return s;
    }
  }

  String _payText(String p) => (p == 'cash') ? 'كاش' : 'بطاقة';

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: Center(child: Text('الرجاء تسجيل الدخول'))),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1115),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1115),
          elevation: 0,
          title: const Text('طلباتي'),
        ),
        body: StreamBuilder(
          stream: _orderService.streamUserOrders(uid),
          builder: (context, snapshot) {
            // ✅ Loading صحيح
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ✅ Error واضح (خصوصاً مشكلة الـ Index)
            if (snapshot.hasError) {
              final err = snapshot.error.toString();

              final needsIndex =
                  err.contains('FAILED_PRECONDITION') &&
                  err.toLowerCase().contains('index');

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151922),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          needsIndex ? Icons.lock_clock : Icons.error_outline,
                          color: needsIndex ? Colors.amber : Colors.redAccent,
                          size: 34,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          needsIndex
                              ? 'لازم تعمل Index للاستعلام في Firestore'
                              : 'صار خطأ في تحميل الطلبات',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          needsIndex
                              ? 'افتح الـ Console وشغّل الرابط اللي يطلع في الكونسول (Create Index) وبعدها ارجع للتطبيق.'
                              : err,
                          style: const TextStyle(color: Colors.white60),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            // ما نقدرش نفتح الرابط تلقائياً بدون package إضافي
                            // لكن الزر مفيد للـ UX فقط
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'شوف الكونسول: فيه رابط Create Index انسخه وافتحه',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.link),
                          label: const Text('كيف نحلها؟'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('لا توجد بيانات'));
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد طلبات',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final d = docs[i].data();

                final status = (d['status'] ?? 'pending').toString();
                final pay = (d['paymentMethod'] ?? 'cash').toString();
                final total = (d['total'] ?? 0).toString();

                // createdAt optional
                String dateText = '';
                final createdAt = d['createdAt'];
                if (createdAt != null && createdAt.toString().isNotEmpty) {
                  try {
                    // Timestamp من Firestore
                    final dt = createdAt.toDate();
                    dateText =
                        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  '
                        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  } catch (_) {
                    dateText = '';
                  }
                }

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF151922),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    title: Row(
                      children: [
                        const Text(
                          'الإجمالي: ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '$total د.ل',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(status).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _statusColor(status).withOpacity(0.35),
                            ),
                          ),
                          child: Text(
                            _statusText(status),
                            style: TextStyle(
                              color: _statusColor(status),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'طريقة الدفع: ${_payText(pay)}',
                            style: const TextStyle(color: Colors.white60),
                          ),
                          if (dateText.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'التاريخ: $dateText',
                              style: const TextStyle(color: Colors.white38),
                            ),
                          ],
                        ],
                      ),
                    ),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                        ),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                      ),
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
