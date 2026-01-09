// search_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositery/search_repo.dart';

final searchControllerProvider =
    StateNotifierProvider<SearchController, AsyncValue<List<dynamic>>>(
        (ref) {
  final repo = SearchRepo(baseUrl: "https://golf.zillowdigital.com");
  return SearchController(repo);
});

class SearchController extends StateNotifier<AsyncValue<List<dynamic>>> {
  final SearchRepo _repo;
  SearchController(this._repo) : super(const AsyncValue.data([]));

  Future<void> searchCustomers({
    required BuildContext context,
    String? search,
    String? status,
    String? serviceType,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await _repo.searchCustomers(
        search: search,
        status: status,
        serviceType: serviceType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        page: page,
        limit: limit,
      );

      if ((res['status'] == 200 || res['status'] == true) &&
          res['data'] != null) {
        final customers = res['data']['customers'] ?? [];
        state = AsyncValue.data(customers);
      } else {
        _showSnack(context, 'Error', res['message'] ?? 'Search failed');
        state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      debugPrint('Search Error: $e');
    }
  }

  void clearResults() {
    state = const AsyncValue.data([]);
  }

  void _showSnack(BuildContext context, String title, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $msg'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
