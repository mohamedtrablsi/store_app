import 'package:flutter/material.dart';

class AppColors {
  /// الخلفية الأساسية للتطبيق (دارك)
  static const Color scaffoldDark = Color(0xFF101217);

  /// اللون الرئيسي (بين الوردي والبرتقالي)
  static const Color primary = Color(0xFFFF4E8A);

  /// اللون الثاني للتدرّج
  static const Color primary2 = Color(0xFFFF8555);

  /// تدرّج لوني جاهز
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary2, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// درجات الكروت
  static const Color cardDark = Color(0xFF181A20);
  static const Color cardSoft = Color(0xFF22232A);

  /// ===== ألوان النصوص =====

  /// النص الأساسي الفاتح
  static const Color textMain = Colors.white;

  /// نص ثانوي باهت
  static const Color textMuted = Color(0xFF9DA3B4);

  /// نص فاتح (مرادف لـ textMain)
  static const Color textLight = textMain;

  /// نص داكن
  static const Color textDark = Color(0xFF1F222A);

  /// لاستخدامات الكود القديمة:
  static const Color textPrimary = textMain;
  static const Color textSecondary = textMuted;

  /// حدود خفيفة للكروت
  static const Color borderSoft = Color(0xFF2C2D33);

  /// لون الأيقونات الثانوية
  static const Color iconMuted = Color(0xFF9DA3B4);

  /// ألوان حالة
  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFFFC857);

  /// لون مميز للأسعار والأزرار
  static const Color accent = primary;
}
