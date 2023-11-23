import 'package:flutter/material.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/chat/presentation/chat_detail_screen.dart';
import 'package:mobile/src/features/chat/presentation/chat_screen.dart';
import 'package:mobile/src/features/history/presentation/history_screen.dart';
import 'package:mobile/src/features/notification/presentation/notification_screen.dart';
import 'package:mobile/src/features/onboarding/data/onboarding_repository.dart';
import 'package:mobile/src/features/profile/presentation/edit_email_screen.dart';
import 'package:mobile/src/features/profile/presentation/edit_password_screen.dart';
import 'package:mobile/src/features/profile/presentation/edit_username_screen.dart';
import 'package:mobile/src/features/profile/presentation/profile_screen.dart';
import 'package:mobile/src/routing/go_router_refresh_stream.dart';
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
  notification,
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
  final authRepository = ref.watch(authRepositoryProvider);
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (path != '/onboarding') {
          return '/onboarding';
        }
      }
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path.startsWith('/login')) {
          return '/home';
        }
      } else {
        if (path.startsWith('/home') ||
            path.startsWith('/notification') ||
            path.startsWith('/history') ||
            path.startsWith('/chat') ||
            path.startsWith('/profile')) {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
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
        path: '/notification',
        name: AppRoute.notification.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: NotificationScreen(),
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
                routes: [
                  GoRoute(
                    path: 'order',
                    name: AppRoute.order.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: OrderScreen(),
                    ),
                  ),
                ],
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
                  child: HistoryScreen(),
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
                    path: ':userId',
                    name: AppRoute.chatDetail.name,
                    pageBuilder: (context, state) {
                      final userId = state.pathParameters['userId']!;
                      return MaterialPage(
                        child: ChatDetailScreen(
                          userId: userId,
                          messageId: '',
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
