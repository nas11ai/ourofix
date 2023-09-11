import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: ThemeColor.primaryColor,
          secondary: ThemeColor.secondaryColor,
          background: ThemeColor.backgroundColor,
          tertiary: ThemeColor.tertiaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
