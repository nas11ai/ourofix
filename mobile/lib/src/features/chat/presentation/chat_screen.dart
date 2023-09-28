import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/constants/theme_colors.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dummy data untuk daftar pesan
    final List<Message> messages = [
      Message('A', 'Alice', 'Halo, apa kabar?'),
      Message('B', 'Bob', 'Hai! Saya baik. Bagaimana denganmu?'),
      // Tambahkan pesan lainnya di sini
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Chat'),
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
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications,
                  color: ThemeColor.primaryColor),
              onPressed: () {
                // Aksi ketika tombol notifikasi ditekan
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            final message = messages[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(message.avatar),
              ),
              title: Text(message.senderName),
              subtitle: Text(message.messagePreview),
              // Tambahkan logika untuk menavigasi ke obrolan penuh di sini
              onTap: () {
                // Tambahkan logika untuk menavigasi ke obrolan penuh atau tindakan lainnya di sini
              },
            );
          },
        ),
      ),
    );
  }
}

class Message {
  final String avatar;
  final String senderName;
  final String messagePreview;

  Message(this.avatar, this.senderName, this.messagePreview);
}
