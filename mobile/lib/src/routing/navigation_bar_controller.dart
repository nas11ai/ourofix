import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_bar_controller.g.dart';

@riverpod
class NavigationBarController extends _$NavigationBarController {
  @override
  bool build() {
    return false;
  }

  void hideNavBar() {
    state = true;
  }

  void showNavBar() {
    state = false;
  }
}
