import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح 🎉')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "خطأ: تحقق من البيانات";

      if (e.code == "email-already-in-use") msg = "هذا البريد مستخدم مسبقًا";
      if (e.code == "weak-password") msg = "كلمة المرور ضعيفة";
      if (e.code == "invalid-email") msg = "البريد الإلكتروني غير صالح";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("خطأ غير متوقع 😅")));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF009688),
          title: const Text(
            'إنشاء حساب جديد',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F2F1), Color(0xFFE0F7FA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Color(0xFF009688),
                          size: 54,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: email,
                          decoration: _inputStyle(
                            'البريد الإلكتروني',
                            Icons.email_outlined,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'أدخل البريد الإلكتروني';
                            }
                            if (!v.contains('@')) return 'البريد غير صالح';
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: pass,
                          obscureText: _obscure,
                          decoration: _inputStyle(
                            'كلمة المرور',
                            Icons.lock_outline,
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
                            if (v.length < 6) {
                              return '6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 26),

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
                            onPressed: _loading ? null : _register,
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'إنشاء الحساب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF009688)),
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF009688), width: 1.5),
      ),
    );
  }
}
