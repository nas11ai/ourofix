import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/responsive_center.dart';
import 'package:mobile/src/common_widgets/secondary_button.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';

import 'package:mobile/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobile/src/routing/app_router.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      backgroundColor: ThemeColor.primaryColor,
      body: ResponsiveCenter(
        maxContentWidth: 450,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    // Gaya teks umum (ukuran, dll.)
                    ),
                children: const [
                  TextSpan(
                    text: 'Selamat datang di\n',
                    style: TextStyle(
                        color: ThemeColor
                            .secondaryColor), // Atur warna teks yang berbeda
                  ),
                  TextSpan(
                    text: 'Ourofix!',
                    style: TextStyle(
                        color: ThemeColor
                            .secondaryTextColor), // Atur warna teks yang berbeda
                  ),
                ],
              ),
            ),
            gapH16,
            const Image(
              image: AssetImage('assets/app_logo.png'),
              height: 200.0,
            ),
            gapH16,
            SecondaryButton(
              text: 'Get Started',
              isLoading: state.isLoading,
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .completeOnboarding();
                      if (context.mounted) {
                        // go to sign in page after completing onboarding
                        context.goNamed(AppRoute.login.name);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
