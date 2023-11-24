import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/chat/data/chat_repository.dart';
import 'package:mobile/src/features/chat/domain/message.dart';
import 'package:mobile/src/features/chat/domain/user.dart';
import 'package:mobile/src/features/chat/presentation/chat_screen_controller.dart';
import 'package:mobile/src/features/chat/presentation/message_box.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String userId;
  final String messageId;

  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.messageId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final chatRepository = ref.watch(chatRepositoryProvider);

    // Fetch user and messages
    chatRepository.getUserByUid(uid: widget.userId);
    chatRepository.getMessages(receiverId: widget.userId);

    final state = ref.watch(chatScreenControllerProvider);

    return StreamBuilder<User?>(
      stream: ref.read(chatRepositoryProvider).userByUid,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (userSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('User tidak ditemukan'),
              leading: IconButton(
                onPressed: () {
                  if (context.mounted) {
                    ref
                        .read(navigationBarControllerProvider.notifier)
                        .showNavBar();
                    context.pop();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: ThemeColor.primaryColor,
                ),
              ),
            ),
            body: Center(
              child: Text('Error: ${userSnapshot.error}'),
            ),
          );
        }

        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('User tidak ditemukan'),
              leading: IconButton(
                onPressed: () {
                  if (context.mounted) {
                    ref
                        .read(navigationBarControllerProvider.notifier)
                        .showNavBar();
                    context.pop();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: ThemeColor.primaryColor,
                ),
              ),
            ),
            body: const Center(
              child: Text('User tidak ditemukan.'),
            ),
          );
        }

        final User user = userSnapshot.data!;

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
                  ref
                      .read(navigationBarControllerProvider.notifier)
                      .showNavBar();
                  context.pop();
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ThemeColor.primaryColor,
              ),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: ThemeColor.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: user.isOnline ? Colors.green : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: ref.read(chatRepositoryProvider).allMessages,
                  builder: (context, messageSnapshot) {
                    print(
                        'connectionState: ${messageSnapshot.connectionState}');
                    if (messageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (messageSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${messageSnapshot.error}'),
                      );
                    }

                    if (messageSnapshot.hasData) {
                      // Data pesan sudah ada, langsung bangun widget dengan data
                      final List<Message> messages =
                          messageSnapshot.data ?? <Message>[];
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isSender = message.senderId == user.uid;
                          final isFirstItem = index == 0;

                          return MessageBox(
                            text: message.content,
                            senderName: isSender ? 'You' : user.name,
                            isSender: isSender,
                            isFirstItem: isFirstItem,
                          );
                        },
                      );
                    }

                    return const Center(
                      child: SizedBox(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: state.messageController,
                              decoration: const InputDecoration(
                                hintText: 'Ketik pesan...',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: ThemeColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: ThemeColor.primaryColor,
                          ),
                          onPressed: () async {
                            final focusScope = FocusScope.of(context);
                            await state.sendMessage(receiverId: user.uid);

                            focusScope.unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
