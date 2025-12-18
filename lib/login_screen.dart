import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register_screen.dart';
import 'user/home_screen.dart';

const String kAdminEmail = 'admin@store.com'; // 👈 إيميل الأدمن

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  bool _isAdminMode = false; // 👈 وضع المدير المخفي

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );

      if (!mounted) return;

      // 👇 حالياً ما نرسلش isAdmin للـ HomeScreen
      // التمييز بين الأدمن والزبون حيكون من الإيميل داخل HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'حدث خطأ، تأكد من البريد وكلمة المرور';

      if (e.code == 'user-not-found') {
        msg = 'البريد الإلكتروني غير موجود ❌';
      } else if (e.code == 'wrong-password') {
        msg = 'كلمة المرور غير صحيحة ❌';
      } else if (e.code == 'invalid-email') {
        msg = 'البريد الإلكتروني غير صالح';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('خطأ غير متوقع 😅')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _activateAdminMode() {
    setState(() {
      _isAdminMode = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ وضع المدير تم تفعيله (أدخل بريد المدير و كلمة مروره)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // الخلفية المتدرجة
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF009688), Color(0xFF00B4D8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // دوائر ديكورية
            Positioned(
              top: -60,
              left: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.10),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),

            // المحتوى الرئيسي
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 👇 شعار المتجر مع LongPress لتفعيل وضع المدير
                    GestureDetector(
                      onLongPress: _activateAdminMode,
                      child: Column(
                        children: [
                          Container(
                            height: size.height * 0.12,
                            width: size.height * 0.12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1.8,
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'متجر نزار للإلكترونيات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'سجّل دخولك واستمتع بالتسوّق',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // 👇 مؤشر صغير لوضع المدير
                          if (_isAdminMode)
                            const Text(
                              '🟢 وضع المدير مفعّل',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // بطاقة زجاجية
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // البريد الإلكتروني
                                TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _inputStyle(
                                    label: 'البريد الإلكتروني',
                                    hint: 'example@email.com',
                                    icon: Icons.email_outlined,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'من فضلك أدخل البريد الإلكتروني';
                                    }
                                    if (!v.contains('@')) {
                                      return 'بريد إلكتروني غير صالح';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 14),

                                // كلمة المرور
                                TextFormField(
                                  controller: _pass,
                                  obscureText: _obscure,
                                  decoration: _inputStyle(
                                    label: 'كلمة المرور',
                                    icon: Icons.lock_outline,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () =>
                                          setState(() => _obscure = !_obscure),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'أدخل كلمة المرور';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 8),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'استرجاع كلمة المرور هنضيفوها لاحقًا 😉',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'نسيت كلمة المرور؟',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF009688),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: _loading ? null : _login,
                                    child: _loading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.3,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'تسجيل الدخول',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ليس لديك حساب؟',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: _goToRegister,
                          child: const Text(
                            'إنشاء حساب جديد',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle({
    required String label,
    String? hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF009688)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.90),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Color(0xFF009688), width: 1.5),
      ),
    );
  }
}
