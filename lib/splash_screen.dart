import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009688), Color(0xFF00B4D8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'أهلاً بك في متجر نزار للإلكترونيات',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'أفضل تجربة لشراء الإلكترونيات 🛒',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
