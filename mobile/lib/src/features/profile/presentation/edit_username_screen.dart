import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_textformfield.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/profile/data/profile_repository.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class EditUsernameScreen extends ConsumerStatefulWidget {
  const EditUsernameScreen({Key? key}) : super(key: key);

  @override
  _EditUsernameScreenState createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends ConsumerState<EditUsernameScreen> {
  final TextEditingController _editUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileRepository = ref.watch(profileRepositoryProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ThemeColor.primaryColor),
          leading: IconButton(
            onPressed: () async {
              final newUsername = _editUsernameController.text.trim();

              if (newUsername.isEmpty && context.mounted) {
                ref.read(navigationBarControllerProvider.notifier).showNavBar();
                context.pop();
              }

              if (newUsername.isNotEmpty) {
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                await profileRepository.updateUserName(newUsername);

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Username updated successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );

                if (context.mounted) {
                  ref
                      .read(navigationBarControllerProvider.notifier)
                      .showNavBar();
                  ref
                      .read(navigationBarControllerProvider.notifier)
                      .showNavBar();
                  context.pop();
                }
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ThemeColor.primaryColor,
            ),
          ),
          title: const Text('Ganti Username'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTextField(
            controller: _editUsernameController,
            labelText: 'Username',
            hintText: '',
          ),
        ),
      ),
    );
  }
}
