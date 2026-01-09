import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_routes.dart';
import 'session/auth_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Golf App',

      // ✅ Force Light Mode Only
      themeMode: ThemeMode.light,

      // ✅ Global Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF2F8B3B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F8B3B),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black),
        ),
        useMaterial3: true,
      ),

      // ✅ Even if system is dark → still light
      darkTheme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF2F8B3B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F8B3B),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        useMaterial3: true,
      ),

      // ✅ Centralized Routes
      routes: AppRoutes.routesMap,

      // ✅ Initial Screen (handles session automatically)
       home: const AuthSession(),
      //initialRoute: AppRoutes.otpForget,
    );
  }
}
