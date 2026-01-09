import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/nav_controller.dart';
import '../../config/app_routes.dart'; // AppRoutes ke paths maintain karne ke liye

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navControllerProvider);
    final navController = ref.read(navControllerProvider.notifier);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_outlined, "Home", 0, selectedIndex, navController),
          GestureDetector(
            onTap: () {
              navController.navigateTo(1);
              Navigator.pushNamed(context, AppRoutes.qrScanner);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          _navItem(context, Icons.search_outlined, "Search", 2, selectedIndex, navController),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    int selectedIndex,
    NavController navController,
  ) {
    final isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        navController.navigateTo(index);
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            break;
          case 2:
            Navigator.pushNamed(context, AppRoutes.search);
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.green : Colors.grey[400], size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.green : Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
