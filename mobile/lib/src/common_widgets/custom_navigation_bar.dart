import 'package:flutter/material.dart';

class NavigationDestination {
  final IconData iconData; // Store IconData for icon
  final IconData selectedIconData; // Store IconData for selectedIcon
  final String label;

  NavigationDestination({
    required this.iconData,
    required this.selectedIconData,
    required this.label,
  });
}

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
    ),
  }) : super(key: key);

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: destinations.asMap().entries.map((entry) {
          final index = entry.key;
          final destination = entry.value;

          final isSelected = index == selectedIndex;

          return InkWell(
            onTap: () => onDestinationSelected(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected
                      ? destination.selectedIconData
                      : destination.iconData,
                  color: isSelected ? Colors.white : Colors.white38,
                ),
                Text(
                  destination.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white38,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
