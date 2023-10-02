import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/routing/app_router.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Profil'),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              gapH32,
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      height: MediaQuery.sizeOf(context).width * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          child: Icon(
                            Icons.person,
                            size: MediaQuery.sizeOf(context).width * 0.25,
                            color: ThemeColor.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.09,
                        height: MediaQuery.sizeOf(context).width * 0.09,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: ThemeColor.primaryColor,
                            size: MediaQuery.sizeOf(context).width * 0.06,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gapH48,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Informasi Akun',
                      style: Theme.of(context).textTheme.titleMedium!.merge(
                            const TextStyle(color: Colors.black),
                          ),
                    ),
                    gapH12,
                    customListTile(
                      context,
                      "Username",
                      "john_doe",
                      () {
                        if (context.mounted) {
                          ref
                              .read(navigationBarControllerProvider.notifier)
                              .hideNavBar();
                          context.goNamed(AppRoute.editUsername.name);
                        }
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      indent: MediaQuery.sizeOf(context).width * 0.042,
                      endIndent: MediaQuery.sizeOf(context).width * 0.08,
                    ),
                    gapH12,
                    customListTile(
                      context,
                      "Email",
                      "john_doe@gmail.com",
                      () {
                        if (context.mounted) {
                          ref
                              .read(navigationBarControllerProvider.notifier)
                              .hideNavBar();
                          context.goNamed(AppRoute.editEmail.name);
                        }
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      indent: MediaQuery.sizeOf(context).width * 0.042,
                      endIndent: MediaQuery.sizeOf(context).width * 0.08,
                    ),
                    gapH12,
                    customListTile(
                      context,
                      "Password",
                      "**********",
                      () {
                        if (context.mounted) {
                          ref
                              .read(navigationBarControllerProvider.notifier)
                              .hideNavBar();
                          context.goNamed(AppRoute.editPassword.name);
                        }
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      indent: MediaQuery.sizeOf(context).width * 0.042,
                      endIndent: MediaQuery.sizeOf(context).width * 0.08,
                    ),
                    gapH12,
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: ThemeColor.secondaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.2,
                      height: MediaQuery.sizeOf(context).width * 0.1,
                      child: const Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(color: ThemeColor.primaryColor),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (context.mounted) {
                        context.goNamed(AppRoute.login.name);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customListTile(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_right,
            color: ThemeColor.primaryColor,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
