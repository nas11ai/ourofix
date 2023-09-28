import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_textformfield.dart';
import 'package:mobile/src/constants/theme_colors.dart';

class EditUsernameScreen extends ConsumerStatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  ConsumerState<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends ConsumerState<EditUsernameScreen> {
  final TextEditingController _editUsernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Flutter',
      home: Scaffold(
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
                  context.pop();
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ThemeColor.primaryColor,
              )),
          title: const Text('Ganti Username'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTextField(
            controller: _editUsernameController,
            labelText: 'Username',
            hintText: 'john_doe',
          ),
        ),
      ),
    );
  }
}
