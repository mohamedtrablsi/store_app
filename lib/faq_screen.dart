import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      'أين يمكنني زيارة فروع متجر نزار؟',
      'ما نوع المنتجات التي نقدمها؟',
      'هل يمكنني طلب منتج غير متوفر لديكم؟',
      'هل توفرون ضمان على المنتجات؟',
      'ما هي طرق الدفع المتاحة؟',
      'هل لديكم خدمة صيانة للأجهزة؟',
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldDark,
        elevation: 0,
        title: const Text('الأسئلة الشائعة'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ExpansionTile(
              collapsedIconColor: AppColors.textMuted,
              iconColor: AppColors.textLight,
              title: Text(
                faqs[index],
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'هنا يكون الجواب التفصيلي للسؤال (نضيفه لاحقًا).',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
