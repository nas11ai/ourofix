import 'package:flutter/material.dart';
import 'package:mobile/src/routing/scaffold_with_nested_navigation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mobile/src/features/login/presentation/login_screen.dart';
import 'package:mobile/src/features/register/presentation/register_screen.dart';
import 'package:mobile/src/features/home/presentation/home_screen.dart';
import 'package:mobile/src/features/home/presentation/order_screen.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _historyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'history');
final _chatNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'chat');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

enum AppRoute {
  onboarding,
  login,
  register,
  home,
  order,
  chat,
  profile,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: AppRoute.register.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RegisterScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
              GoRoute(
                path: '/order',
                name: AppRoute.order.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: OrderScreen(),
                ),
              ),
            ],
          ),
        ],
      )
    ],
  );
}
