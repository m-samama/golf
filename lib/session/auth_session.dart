import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_routes.dart';

class AuthSession extends StatefulWidget {
  const AuthSession({super.key});

  @override
  State<AuthSession> createState() => _AuthSessionState();
}

class _AuthSessionState extends State<AuthSession> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _handleSessionCheck();
  }

  Future<void> _handleSessionCheck() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final isVerified = prefs.getBool('is_verified') ?? false;

      debugPrint("🟢 TOKEN FOUND: $token");
      debugPrint("🟢 IS VERIFIED: $isVerified");

      // Optional splash delay for UX
      await Future.delayed(const Duration(seconds: 1));

      String nextRoute;
      if (token == null || token.isEmpty) {
        nextRoute = AppRoutes.login;
      } else if (!isVerified) {
        nextRoute = AppRoutes.login;
      } else {
        nextRoute = AppRoutes.dashboard;
      }

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, nextRoute);
        });
      }
    } catch (e) {
      debugPrint("❌ Session check error: $e");
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        });
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _checking
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
