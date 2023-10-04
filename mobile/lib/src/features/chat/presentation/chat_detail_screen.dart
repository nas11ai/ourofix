import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class ChatDetailScreen extends ConsumerWidget {
  final String messageId;

  const ChatDetailScreen({
    super.key,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dapatkan pesan yang sesuai berdasarkan messageId
    final ChatMessage? message = getMessageById(messageId);

    if (message == null) {
      // Pesan tidak ditemukan, tampilkan pesan atau widget lain sesuai kebutuhan
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pesan tidak ditemukan'),
        ),
        body: const Center(
          child: Text('Pesan tidak ditemukan.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: ThemeColor.primaryColor),
        leading: IconButton(
            onPressed: () {
              if (context.mounted) {
                ref.read(navigationBarControllerProvider.notifier).showNavBar();
                context.pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ThemeColor.primaryColor,
            )),
        title: Text(message.senderName),
      ),
      body: Column(
        children: [
          gapH16,
          Expanded(
            child: ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                final msg = messageList[index];
                final isSender = msg.senderName == message.senderName;
                final bgColor =
                    isSender ? Colors.grey.shade400 : ThemeColor.primaryColor;
                final textColor = isSender
                    ? ThemeColor.primaryColor
                    : ThemeColor.tertiaryColor;
                final bool isFirstItem = index == 0;

                return Padding(
                  padding: isSender
                      ? isFirstItem
                          ? const EdgeInsets.only(
                              right: Sizes.p48,
                              left: Sizes.p16,
                            )
                          : const EdgeInsets.only(
                              right: Sizes.p48,
                              left: Sizes.p16,
                              top: Sizes.p16,
                            )
                      : isFirstItem
                          ? const EdgeInsets.only(
                              left: Sizes.p48,
                              right: Sizes.p16,
                            )
                          : const EdgeInsets.only(
                              left: Sizes.p48,
                              right: Sizes.p16,
                              top: Sizes.p16,
                            ),
                  child: Align(
                    alignment:
                        isSender ? Alignment.centerLeft : Alignment.centerRight,
                    child: Card(
                      color: bgColor,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          '${msg.text} ngentooooooooooooooooooooooooooooooooooooooooooooot',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: ThemeColor.primaryColor),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: ThemeColor.primaryColor,
                    ),
                    onPressed: () {
                      // Tambahkan logika untuk mengirim pesan di sini
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mendapatkan pesan berdasarkan messageId
  ChatMessage? getMessageById(String messageId) {
    // Implementasikan logika untuk mendapatkan pesan dari daftar pesan berdasarkan messageId
    // Misalnya, Anda dapat mencari pesan dalam daftar pesan Anda.
    // Jika pesan ditemukan, kembalikan objek pesan; jika tidak, kembalikan null.
    // Contoh implementasi:
    for (var message in messageList) {
      if (message.id == messageId) {
        return message;
      }
    }
    return null; // Pesan tidak ditemukan.
  }
}

class ChatMessage {
  final String id;
  final String senderName;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });
}

final List<ChatMessage> messageList = [
  ChatMessage(
    id: '1',
    senderName: 'Alice',
    text: 'Halo, apa kabar? tes 1 2 3',
    timestamp: DateTime.now().subtract(Duration(hours: 2)),
  ),
  ChatMessage(
    id: '2',
    senderName: 'Bob',
    text: 'Hai! Saya baik. Bagaimana denganmu?',
    timestamp: DateTime.now().subtract(Duration(hours: 1)),
  ),
  // Tambahkan pesan lainnya di sini
];
