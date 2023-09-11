import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/src/features/onboarding/data/onboarding_repository.dart';

part 'onboarding_controller.g.dart';

// @riverpod
// class SplashController extends _$SplashController {
//   @override
//   bool build() {
//     return false;
//   }

//   Future<void> delayAndNavigate() async {
//     await Future.delayed(const Duration(seconds: 2));
//     state = true;
//   }
// }
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {}

  Future<void> completeOnboarding() async {
// ignore: avoid_manual_providers_as_generated_provider_dependency
    final onboardingRepository = ref.watch(onboardingRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(onboardingRepository.setOnboardingComplete);
  }
}
