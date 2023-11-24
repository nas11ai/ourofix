import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/routing/app_router.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dummy data untuk daftar pesan
    final List<Notification> notifications = [
      Notification('1', '!', 'Ayo, verifikasi email-mu!',
          'Lengkapi data dirimu, dan dapatkan promo menarik sekarang juga!'),
      Notification('2', 'X', 'Pesanan dibatalkan!',
          'Pengajuan pembatalan pesanan berhasil'),
      // Tambahkan pesan lainnya di sini
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (context.mounted) {
                    context.goNamed(AppRoute.home.name);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: ThemeColor.primaryColor,
                )),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Notification'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2.0),
              child: Container(
                color: ThemeColor.primaryColor,
                height: 2.0,
              ),
            ),
            titleTextStyle: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: ThemeColor.primaryColor),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                final notification = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(notification.avatar),
                  ),
                  title: Text(notification.senderName),
                  subtitle: Text(notification.notificationPreview),
                );
              },
            ),
          )),
    );
  }
}

class Notification {
  final String id;
  final String avatar;
  final String senderName;
  final String notificationPreview;

  Notification(
    this.id,
    this.avatar,
    this.senderName,
    this.notificationPreview,
  );
}
