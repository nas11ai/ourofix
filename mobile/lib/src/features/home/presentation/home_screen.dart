import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications, color: ThemeColor.primaryColor),
            onPressed: () {
              // Aksi ketika tombol notifikasi ditekan
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Apa keluhan anda?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(
              "Ini yang sering dikeluhkan pelanggan kami",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Padding(
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
                          text: "Instal Ulang", icon: Icons.laptop),
                      buildServiceButton(
                          text: "Tidak Bisa Nyala",
                          icon: Icons.power_settings_new),
                      buildServiceButton(
                          text: "Device Lemot", icon: Icons.remove_circle),
                      buildServiceButton(
                          text: "Charger Rusak", icon: Icons.power_off),
                    ],
                  );
                },
              ),
            ),
            gapH12,
            // Carousel
            buildImageCarousel(context),
          ],
        ),
      ),
    );
  }

  Widget buildServiceButton({required String text, required IconData? icon}) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 75, color: ThemeColor.primaryColor),
          Text(text),
        ],
      ),
    );
  }

  Widget buildImageCarousel(BuildContext context) {
    return CarouselSlider(
      items: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: Colors.amber,
          child: const Center(child: Text('Iklan 1')),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: Colors.blue,
          child: const Center(child: Text('Iklan 2')),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: Colors.lightGreen,
          child: const Center(child: Text('Iklan 3')),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: Colors.cyan,
          child: const Center(child: Text('Iklan 4')),
        ),
      ],
      options: CarouselOptions(
        height: MediaQuery.sizeOf(context).height * 0.1,
        autoPlay: true, // Berpindah otomatis
        aspectRatio: 16 / 9, // Sesuaikan dengan rasio gambar Anda
        enlargeCenterPage: true, // Memperbesar gambar tengah
        enableInfiniteScroll: true, // Scroll tak terbatas
        viewportFraction: 0.94, // Ukuran gambar dalam carousel
      ),
    );
  }
}
