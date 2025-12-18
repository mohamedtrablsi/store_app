import 'package:flutter/material.dart';
import '../services/order_service.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = OrderService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إدارة الطلبات')),
        body: StreamBuilder(
          stream: service.streamAllOrders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final docs = (snapshot.data!).docs;
            if (docs.isEmpty) return const Center(child: Text('لا توجد طلبات'));

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final doc = docs[i];
                final d = doc.data();
                final status = (d['status'] ?? 'pending').toString();
                final pay = (d['paymentMethod'] ?? 'cash').toString();
                final total = (d['total'] ?? 0).toString();

                return Card(
                  child: ListTile(
                    title: Text('الإجمالي: $total د.ل'),
                    subtitle: Text(
                      'الدفع: ${pay == 'cash' ? 'كاش' : 'بطاقة'}\nالحالة: $status',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (val) =>
                          service.updateOrderStatus(doc.id, val),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'pending', child: Text('pending')),
                        PopupMenuItem(
                          value: 'processing',
                          child: Text('processing'),
                        ),
                        PopupMenuItem(
                          value: 'delivered',
                          child: Text('delivered'),
                        ),
                        PopupMenuItem(
                          value: 'cancelled',
                          child: Text('cancelled'),
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
