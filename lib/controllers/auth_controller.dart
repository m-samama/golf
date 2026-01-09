import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:golf/views/auth/otpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_routes.dart';
import '../repositery/aut_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<bool> {
  final Ref ref;
  final AuthRepository _repo = AuthRepository();

  AuthController(this.ref) : super(false);

  /// ✅ Safe snackbar with context
  void _safeShowMessage(BuildContext context, String title, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title: $message'),
          backgroundColor: title == 'Success' ? Colors.green : Colors.redAccent,
        ),
      );
    }
  }

  // 🔹 REGISTER (Riverpod + Safe Snackbar)
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    BuildContext context,
  ) async {
    state = true; // loading start

    try {
      final res = await _repo.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      state = false; // loading end

      if (res['status'] == false) {
        // ✅ OTP sent successfully, go to OTP screen
        _safeShowMessage(context, 'Success', 'OTP sent to your email');
        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.otp,
            arguments: {'email': email},
          );
        }
      } else {
        // ❌ Registration failed
        _safeShowMessage(
          context,
          'Error',
          res['message'] ?? 'Something went wrong',
        );
      }

      return res;
    } catch (e) {
      state = false;
      _safeShowMessage(context, 'Error', e.toString());
      return {'status': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(
    String email,
    String otp,
    bool isReset,
    BuildContext context,
  ) async {
    state = true;
    try {
      // ✅ Use the correct isReset flag
      final res = await _repo.verifyOtp(
        email: email,
        otp: otp,
        isReset: isReset,
      );
      print("🔹 OTP Verify Response: $res");
      state = false;

      if (res['status'] == true) {
        _safeShowMessage(context, 'Success', 'OTP verified successfully');

        final prefs = await SharedPreferences.getInstance();
        final token =
            res['data']?['token'] ??
            res['token'] ??
            res['data']?['access_token'];

        if (token != null) {
          await prefs.setString('token', token);
          print("✅ Token saved: $token");
        } else {
          print("⚠️ Token missing in response!");
        }

        await prefs.setString('user_email', email);
        await prefs.setBool('is_verified', true);

        // ✅ Redirect correctly
        if (isReset) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard, // change from login → dashboard
            (route) => false,
          );
        }
      } else {
        _safeShowMessage(context, 'Error', res['message'] ?? 'Invalid OTP');
      }

      return res;
    } catch (e) {
      state = false;
      print("❌ OTP Verification Error: $e");
      _safeShowMessage(context, 'Error', e.toString());
      return {'status': false, 'message': e.toString()};
    }
  }

  // 🔹 RESEND OTP
  Future<void> resendOtp(String email, BuildContext context) async {
    state = true;
    final res = await _repo.resendOtp(email: email);
    state = false;
    _safeShowMessage(
      context,
      res['status'] ? 'Success' : 'Error',
      res['message'],
    );
  }

  // 🔹 UPDATED LOGIN FUNCTION (Handles backend verification check)
  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = true;
    try {
      final res = await _repo.login(email: email, password: password);
      state = false;

      // ✅ CASE 1: Login successful and user verified
      if (res['status'] == true && res['data'] != null) {
        final user = res['data']['user'];

        print('✅ LOGIN SUCCESS - User verified');
        print('User Data: $user');

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', res['data']['token']);
        await prefs.setString('user_email', email);
        await prefs.setBool('is_verified', true); // ✅ Added line

        print('💾 Token saved to SharedPreferences');

        // Go to dashboard
        _safeShowMessage(context, 'Success', 'Login successful');

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        }
      }
      // ✅ CASE 2: Login failed because user not verified
      else if (res['status'] == false &&
          res['message']?.toLowerCase().contains('verify') == true) {
        _safeShowMessage(
          context,
          'Account Not Verified',
          'Sending OTP to your email...',
        );

        // 🔹 Resend OTP API call
        final resend = await _repo.resendOtp(email: email);

        final bool resendSuccess =
            resend['status'] == true ||
            resend['status'] == 'success' ||
            resend['status'] == 1 ||
            (resend['message']?.toString().toLowerCase().contains('otp') ??
                false);

        if (resendSuccess) {
          print('✅ OTP sent successfully');
          _safeShowMessage(
            context,
            'OTP Sent',
            'OTP sent successfully! Please verify your account.',
          );
        } else {
          print('⚠️ OTP resend response: ${resend.toString()}');
          _safeShowMessage(
            context,
            'Notice',
            'Could not confirm OTP send, please check your email manually.',
          );
        }

        // 🔹 Redirect to OTP screen (always redirect)
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OTPScreen(email: email, isReset: false),
            ),
          );
        } else {
          // Even if OTP send fails, still redirect to OTP screen
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OTPScreen(email: email, isReset: false),
              ),
            );
          }
        }
      }
      // ✅ CASE 3: Other login failures (wrong password, etc.)
      else {
        print('❌ LOGIN FAILED: ${res['message']}');
        _safeShowMessage(
          context,
          'Error',
          res['message'] ?? 'Invalid credentials',
        );
      }
    } catch (e) {
      state = false;
      print('💥 LOGIN EXCEPTION: $e');
      _safeShowMessage(context, 'Error', 'Login failed: ${e.toString()}');
    }

    print('🔚 LOGIN PROCESS COMPLETED');
  }

  // 🔹 FORGOT PASSWORD
  Future<void> forgotPassword(String email, BuildContext context) async {
    state = true;
    final res = await _repo.forgotPassword(email: email);
    state = false;

    if (res['status'] == true) {
      _safeShowMessage(context, 'Success', 'OTP sent to your email');

      // Navigate to OTP screen with email + isReset
      Navigator.pushNamed(
        context,
        AppRoutes.otpForget,
        arguments: {'email': email, 'isReset': true},
      );
    } else {
      _safeShowMessage(
        context,
        'Error',
        res['message'] ?? 'Something went wrong',
      );
    }
  }

  // 🔹 VERIFY OTP (Forgot Password)
  Future<void> verifyOtpForget(
    String email,
    String otp,
    BuildContext context,
  ) async {
    state = true;
    final res = await _repo.verifyOtp(email: email, otp: otp, isReset: true);
    state = false;

    if (res['status'] == false) {
      _safeShowMessage(context, 'Success', 'OTP verified successfully');

      // Navigate to Reset Password Screen
      Navigator.pushNamed(
        context,
        AppRoutes.resetPassword,
        arguments: {'email': email, 'otp': otp}, // pass OTP to reset screen
      );
    } else {
      _safeShowMessage(context, 'Error', res['message'] ?? 'Invalid OTP');
    }
  }

  // 🔹 RESET PASSWORD
  Future<void> resetPassword(
    String email,
    String otp,
    String newPass,
    String confirmPass,
    BuildContext context,
  ) async {
    state = true;

    try {
      final res = await _repo.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPass,
        confirmPassword: confirmPass,
      );

      state = false;

      if (res['status'] == false) {
        _safeShowMessage(context, 'Success', 'Password reset successfully');

        // ✅ Navigate to login screen after success
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        });
      } else {
        _safeShowMessage(context, 'Error', res['message'] ?? 'Reset failed');
      }
    } catch (e) {
      state = false;
      _safeShowMessage(context, 'Error', e.toString());
    }
  }

  // 🔹 LOGOUT
  Future<void> logout(BuildContext context) async {
    state = true;
    final res = await _repo.logout();
    state = false;

    // ✅ Handle both valid and expired token cases
    if (res['status'] == true ||
        (res['message']?.toLowerCase().contains('expired') ?? false)) {
      // Always clear session on logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _safeShowMessage(context, 'Success', 'Logged out successfully.');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } else {
      _safeShowMessage(context, 'Error', res['message']);
    }
  }
}
