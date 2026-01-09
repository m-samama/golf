import 'package:flutter/material.dart';

// 🔹 Auth Screens
import 'package:golf/views/auth/login.dart';
import 'package:golf/views/auth/otpScreen.dart';
import 'package:golf/views/auth/otp_forget.dart';
import 'package:golf/views/auth/reset_password.dart';

// 🔹 Dashboard
import 'package:golf/views/dashboard/dashborad.dart';

// 🔹 QR Scanner
import 'package:golf/views/qr%20scannar/add_customer.dart';
import 'package:golf/views/qr%20scannar/edit_customer.dart';

// 🔹 Search
import 'package:golf/views/search/search.dart';

// 🔹 Settings
import 'package:golf/views/settings/change_password.dart';
import 'package:golf/views/settings/edit_profile.dart';
import 'package:golf/views/settings/setting.dart';

// 🔹 Storage
import 'package:golf/views/storage/details_screen.dart';
import 'package:golf/views/storage/overdue_screen.dart';
import 'package:golf/views/storage/playing_screen.dart';
import 'package:golf/views/storage/storage_screen.dart';
import 'package:golf/views/storage/takeoff_screen.dart';

class AppRoutes {
  // 🔹 Route Names
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String otp = '/otp';
  static const String otpForget = '/otp-forget';
  static const String resetPassword = '/reset-password';
  static const String qrScanner = '/qr-scanner';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String editcustomer = '/edit-customer';
  static const String changePassword = '/change-password';
  static const String storage = '/storage';
  static const String playing = '/playing';
  static const String overdue = '/overdue';
  static const String takeoff = '/takeoff';
  static const String details = '/details';

  // 🔹 Routes Map
  static final Map<String, WidgetBuilder> routesMap = {
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardView(),

    // 🔸 QR & Search
    qrScanner: (context) => const AddCustomerScreen(),
    search: (context) => SearchScreen(),

    // 🔸 Settings
    settings: (context) => const SettingsView(),
    editcustomer: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      final customerId = args?['customerId'] ?? '';
      return EditCustomerView(customerId: customerId);
    },

    editProfile: (context) => const EditProfileView(),
    changePassword: (context) => const ChangePasswordView(),

    // 🔸 Storage
    storage: (context) => StorageScreen(),
    playing: (context) => PlayingScreen(),
    overdue: (context) => OverdueScreen(),
    takeoff: (context) => TakeOffScreen(),
    details: (context) => DetailsScreen(),

    // 🔸 Password Reset
    resetPassword: (context) => const ResetPasswordView(),

    // 🔸 OTP (register / reset both handled)
    otp: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      final email = args?['email'] ?? '';
      final isReset = args?['isReset'] ?? false;
      return OTPScreen(email: email, isReset: isReset);
    },

    otpForget: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      final email = args?['email'] ?? '';
      final isReset = args?['isReset'] ?? false;
      return OTPForgetScreen(email: email, isReset: isReset);
    },
  };
}
