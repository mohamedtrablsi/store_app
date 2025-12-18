import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import 'splash_screen.dart';

import 'services/auth_service.dart';
import 'admin/admin_dashboard.dart';
import 'user/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'متجر نزار للإلكترونيات',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (!snapshot.hasData) {
            return const LoginScreen();
          }

          final user = snapshot.data!;
          return FutureBuilder<bool>(
            future: AuthService().isAdmin(user.uid),
            builder: (context, adminSnap) {
              if (adminSnap.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              final isAdmin = adminSnap.data ?? false;
              return isAdmin ? const AdminDashboard() : const HomeScreen();
            },
          );
        },
      ),
    );
  }
}
