import 'package:flutter_riverpod/legacy.dart';

final navControllerProvider =
    StateNotifierProvider<NavController, int>((ref) => NavController());

class NavController extends StateNotifier<int> {
  NavController() : super(0);

  void navigateTo(int index) {
    state = index;
  }
}
