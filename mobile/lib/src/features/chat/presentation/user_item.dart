import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/features/chat/domain/user.dart';
import 'package:mobile/src/routing/app_router.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class UserItem extends ConsumerWidget {
  const UserItem({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.image),
            ),
            CircleAvatar(
              radius: 5,
              backgroundColor: user.isOnline ? Colors.green : Colors.grey,
            ),
          ],
        ),
        title: Text(user.name),
        subtitle: Text(user.messagePreview),
        // Tambahkan logika untuk menavigasi ke obrolan penuh di sini
        onTap: () {
          ref.read(navigationBarControllerProvider.notifier).hideNavBar();
          context.goNamed(AppRoute.chatDetail.name,
              pathParameters: {'userId': user.uid});
        },
      );
}
