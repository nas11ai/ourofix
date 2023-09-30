import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/secondary_button.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/home/presentation/home_controller.dart';
import 'package:mobile/src/routing/app_router.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // print('selectedCardIndexes: ${ref.watch(selectedIndexControllerProvider)}');

    final bool isButtonVisible = ref.watch(navigationBarControllerProvider);

    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildImageCarousel(context),
              gapH16,
              buildHeader(),
              buildServiceButtons(),
              gapH16,
              buildOrderButton(isButtonVisible, context),
            ],
          ),
        ),
      ),
    );
  }

  Visibility buildOrderButton(bool isButtonVisible, BuildContext context) {
    return Visibility(
      visible: isButtonVisible,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: SecondaryButton(
            text: 'Pesan',
            onPressed: () {
              if (context.mounted) {
                context.goNamed(AppRoute.order.name);
              }
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'OuroFix',
        style: TextStyle(color: ThemeColor.primaryColor),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: ThemeColor.primaryColor),
          onPressed: () {
            if (context.mounted) {
              context.goNamed(AppRoute.notification.name);
            }
          },
        ),
      ],
    );
  }

  Widget buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Apa keluhan anda?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Ini yang sering dikeluhkan pelanggan kami",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildServiceButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          if (constraints.maxWidth >= 600) {
            crossAxisCount = 3;
          }
          return GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              buildServiceButton(
                text: "Instal Ulang",
                icon: Icons.laptop,
                index: 1,
                isSelected: ref
                    .watch(selectedIndexControllerProvider.notifier)
                    .contains(1),
                onTap: () => onServiceButtonTapped(1),
              ),
              buildServiceButton(
                text: "Tidak Bisa Nyala",
                icon: Icons.power_settings_new,
                index: 2,
                isSelected: ref
                    .watch(selectedIndexControllerProvider.notifier)
                    .contains(2),
                onTap: () => onServiceButtonTapped(2),
              ),
              buildServiceButton(
                text: "Device Lemot",
                icon: Icons.remove_circle,
                index: 3,
                isSelected: ref
                    .watch(selectedIndexControllerProvider.notifier)
                    .contains(3),
                onTap: () => onServiceButtonTapped(3),
              ),
              buildServiceButton(
                text: "Charger Rusak",
                icon: Icons.power_off,
                index: 4,
                isSelected: ref
                    .watch(selectedIndexControllerProvider.notifier)
                    .contains(4),
                onTap: () => onServiceButtonTapped(4),
              ),
            ],
          );
        },
      ),
    );
  }

  void onServiceButtonTapped(int index) {
    setState(() {
      if (ref.watch(selectedIndexControllerProvider).contains(index)) {
        ref.read(selectedIndexControllerProvider.notifier).remove(index);
      } else {
        ref.read(selectedIndexControllerProvider.notifier).add(index);
      }

      ref
          .read(selectedIndexControllerProvider.notifier)
          .updateNavbarVisibility();
    });
  }

  Widget buildServiceButton({
    required String text,
    required IconData? icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // print('string: $text, isSelected: $isSelected');
    return Card(
      elevation: 2,
      color: isSelected ? Colors.lightGreen.withOpacity(0.5) : null,
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.green),
            )
          : null,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 75, color: ThemeColor.primaryColor),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget buildImageCarousel(BuildContext context) {
    return CarouselSlider(
      items: [
        buildCarouselItem(context, 'Iklan 1', Colors.amber),
        buildCarouselItem(context, 'Iklan 2', Colors.blue),
        buildCarouselItem(context, 'Iklan 3', Colors.lightGreen),
        buildCarouselItem(context, 'Iklan 4', Colors.cyan),
      ],
      options: CarouselOptions(
        height: MediaQuery.sizeOf(context).height * 0.1,
        autoPlay: true,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.94,
      ),
    );
  }

  Widget buildCarouselItem(BuildContext context, String text, Color color) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: color,
      child: Center(child: Text(text)),
    );
  }
}
