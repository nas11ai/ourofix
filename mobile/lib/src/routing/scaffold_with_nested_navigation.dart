// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_navigation_bar.dart'
    // ignore: library_prefixes
    as CustomNavBar;
import 'package:mobile/src/constants/location.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/routing/app_router.dart';

final List<AppRoute> routesToHideScaffold = [
  AppRoute.order,
];

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return size.width < 450
        ? ScaffoldWithNavigationBar(
            body: navigationShell,
            currentIndex: navigationShell.currentIndex,
            onDestinationSelected: _goBranch,
          )
        : ScaffoldWithNavigationRail(
            body: navigationShell,
            currentIndex: navigationShell.currentIndex,
            onDestinationSelected: _goBranch,
          );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final currentRouteName = GoRouter.of(context).location();

    final isHiddenRoute = routesToHideScaffold.any(
      (route) => '/${route.name}' == currentRouteName,
    );

    return Scaffold(
      body: body,
      floatingActionButton: Visibility(
        visible: !isHiddenRoute,
        child: Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.02,
          ),
          height: MediaQuery.of(context).size.height * 0.07,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                if (context.mounted) {
                  context.goNamed(AppRoute.order.name);
                }
              },
              backgroundColor: ThemeColor.secondaryColor,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Visibility(
        visible: !isHiddenRoute,
        child: CustomNavBar.CustomNavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            CustomNavBar.NavigationDestination(
              iconData: Icons.home,
              selectedIconData: Icons.home,
              label: 'Home',
            ),
            CustomNavBar.NavigationDestination(
              iconData: Icons.history,
              selectedIconData: Icons.history,
              label: 'Riwayat',
            ),
            CustomNavBar.NavigationDestination(
              iconData: Icons.chat_bubble,
              selectedIconData: Icons.chat_bubble,
              label: 'Chat',
            ),
            CustomNavBar.NavigationDestination(
              iconData: Icons.person,
              selectedIconData: Icons.person,
              label: 'Profil',
            ),
          ],
          backgroundColor: ThemeColor.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.02,
        ),
        height: MediaQuery.of(context).size.height * 0.07,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              if (context.mounted) {
                context.goNamed(AppRoute.order.name);
              }
            },
            backgroundColor: ThemeColor.secondaryColor,
            child: const Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work),
                label: Text('Jobs'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_headline_outlined),
                selectedIcon: Icon(Icons.view_headline),
                label: Text('Entries'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Account'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
