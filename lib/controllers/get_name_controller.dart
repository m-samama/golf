import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositery/get_name-repo.dart';

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<String?>>(
  (ref) => ProfileController(ref),
);

class ProfileController extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  final ProfileRepository _repo = ProfileRepository();

  ProfileController(this.ref) : super(const AsyncValue.loading()) {
    getUserName();
  }

  Future<void> getUserName() async {
    try {
      state = const AsyncValue.loading();
      final name = await _repo.getProfileName();
      state = AsyncValue.data(name);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
