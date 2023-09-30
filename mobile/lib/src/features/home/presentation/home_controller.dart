import 'package:mobile/src/routing/navigation_bar_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class SelectedIndexController extends _$SelectedIndexController {
  @override
  Set<int> build() {
    return {};
  }

  void remove(int value) {
    state.remove(value);
  }

  void add(int value) {
    state.add(value);
  }

  void clear() {
    state.clear();
  }

  bool contains(int value) {
    return state.contains(value);
  }

  void updateNavbarVisibility() {
    if (state.isEmpty) {
      ref.read(navigationBarControllerProvider.notifier).showNavBar();
    } else {
      ref.read(navigationBarControllerProvider.notifier).hideNavBar();
    }
  }
}
