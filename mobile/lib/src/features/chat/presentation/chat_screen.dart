import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/chat/data/chat_repository.dart';
import 'package:mobile/src/features/chat/presentation/user_item.dart';
import 'package:mobile/src/routing/app_router.dart';
import 'package:mobile/src/features/chat/domain/user.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    chatRepository.getAllUsers();

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
                if (context.mounted) {
                  context.goNamed(AppRoute.notification.name);
                }
              },
            ),
          ],
        ),
        body: StreamBuilder<List<User>>(
          stream: chatRepository.allUsers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;

              return ListView.separated(
                itemCount: users.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1.0,
                ),
                itemBuilder: (BuildContext context, int index) =>
                    users[index].uid !=
                            ref.watch(firebaseAuthProvider).currentUser?.uid
                        ? UserItem(user: users[index])
                        : const SizedBox(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
