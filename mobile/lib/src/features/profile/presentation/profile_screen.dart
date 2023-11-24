import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/chat/domain/user.dart';
import 'package:mobile/src/features/login/presentation/login_screen_controller.dart';
import 'package:mobile/src/features/profile/data/profile_repository.dart';
import 'package:mobile/src/routing/app_router.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilRepository = ref.watch(profileRepositoryProvider);
    profilRepository.getCurrentUser();

    Future<File?> pickImage(BuildContext context) async {
      File? imageFile;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Sumber Gambar'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    imageFile = File(pickedFile.path);
                    print('imageFile: $imageFile');
                  }

                  navigator.pop();
                },
                child: const Text('Kamera'),
              ),
              TextButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    imageFile = File(pickedFile.path);
                    print('imageFile: $imageFile');
                  }
                  navigator.pop();
                },
                child: const Text('Folder'),
              ),
            ],
          );
        },
      );

      return imageFile;
    }

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
        body: StreamBuilder<User?>(
          stream: ref.read(profileRepositoryProvider).currentUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.hasData) {
              final user = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    gapH32,
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            height: MediaQuery.sizeOf(context).width * 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: user.image.isNotEmpty
                                  ? Image.network(user.image)
                                  : DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: MediaQuery.sizeOf(context).width *
                                            0.25,
                                        color: ThemeColor.primaryColor,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.075,
                              height: MediaQuery.sizeOf(context).width * 0.075,
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
                                onPressed: () async {
                                  final imageFile = await pickImage(context);
                                  print("imageFile: $imageFile");
                                  if (imageFile != null) {
                                    await ref
                                        .watch(profileRepositoryProvider)
                                        .uploadImage(imageFile);
                                    ref
                                        .read(profileRepositoryProvider)
                                        .currentUser;
                                  }
                                },
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
                            style:
                                Theme.of(context).textTheme.titleMedium!.merge(
                                      const TextStyle(color: Colors.black),
                                    ),
                          ),
                          gapH12,
                          customListTile(
                            context,
                            "Nama",
                            user.name,
                            () {
                              if (context.mounted) {
                                ref
                                    .read(navigationBarControllerProvider
                                        .notifier)
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
                            "Role",
                            user.role,
                            () {},
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
                            side: const BorderSide(
                                color: ThemeColor.secondaryColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            height: MediaQuery.sizeOf(context).width * 0.1,
                            child: const Center(
                              child: Text(
                                'Logout',
                                style:
                                    TextStyle(color: ThemeColor.primaryColor),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final isLoggedInGoogle =
                                await googleSignIn.isSignedIn();
                            if (isLoggedInGoogle) {
                              await googleSignIn.disconnect();
                            }

                            await ref.read(firebaseAuthProvider).signOut();

                            if (context.mounted) {
                              context.goNamed(AppRoute.login.name);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Error tidak dihandle'),
            );
          },
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
