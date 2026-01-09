import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/dashboard_model.dart';
import '../repositery/dashboard_repo.dart';
final dashboardProvider =
    StateNotifierProvider<DashboardController, List<DashboardItem>>((ref) {
  return DashboardController(ref);
});

class DashboardController extends StateNotifier<List<DashboardItem>> {
  final Ref ref;
  final DashboardRepository _repo =
      DashboardRepository(baseUrl: 'https://golf.zillowdigital.com/'); // 🟣 Replace with your base URL

  DashboardController(this.ref) : super([]) {
    fetchDashboardCounts();
  }

  Future<void> fetchDashboardCounts() async {
    try {
      final counts = await _repo.getDashboardCounts();

      if (counts.isNotEmpty) {
        state = [
          DashboardItem(
            title: 'STORAGE',
            value: '${counts['Storage'] ?? 0}',
            icon: Icons.storage,
            color: const Color(0xFFFFE4B5),
          ),
          DashboardItem(
            title: 'PLAYING',
            value: '${counts['Playing'] ?? 0}',
            icon: Icons.sports_golf,
            color: const Color(0xFFE8F5E8),
          ),
          DashboardItem(
            title: 'OVERDUE',
            value: '${counts['Overdue'] ?? 0}',
            icon: Icons.access_time,
            color: const Color(0xFFFFE4E1),
          ),
          DashboardItem(
            title: 'TAKE OFF',
            value: '${counts['Take Off'] ?? 0}',
            icon: Icons.flight_takeoff,
            color: const Color(0xFFE5E5E5),
          ),
        ];
      }
    } catch (e) {
      print('❌ Error fetching dashboard counts: $e');
    }
  }
}
