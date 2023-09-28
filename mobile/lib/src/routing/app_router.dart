import 'package:flutter/material.dart';
import 'package:mobile/src/features/chat/presentation/chat_detail_screen.dart';
import 'package:mobile/src/features/chat/presentation/chat_screen.dart';
import 'package:mobile/src/features/profile/presentation/edit_email_screen.dart';
import 'package:mobile/src/features/profile/presentation/edit_password_screen.dart';
import 'package:mobile/src/features/profile/presentation/edit_username_screen.dart';
import 'package:mobile/src/features/profile/presentation/profile_screen.dart';
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
  history,
  chat,
  chatDetail,
  profile,
  editUsername,
  editEmail,
  editPassword,
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
      GoRoute(
        path: '/order',
        name: AppRoute.order.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OrderScreen(),
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
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _historyNavigatorKey,
            routes: [
              GoRoute(
                path: '/history',
                name: AppRoute.history.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Placeholder(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _chatNavigatorKey,
            routes: [
              GoRoute(
                path: '/chat',
                name: AppRoute.chat.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ChatScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':messageId',
                    name: AppRoute.chatDetail.name,
                    pageBuilder: (context, state) {
                      final messageId = state.pathParameters['messageId']!;
                      return MaterialPage(
                        child: ChatDetailScreen(
                          messageId: messageId,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'username/edit',
                    name: AppRoute.editUsername.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: EditUsernameScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'email/edit',
                    name: AppRoute.editEmail.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: EditEmailScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'password/edit',
                    name: AppRoute.editPassword.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: EditPasswordScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
