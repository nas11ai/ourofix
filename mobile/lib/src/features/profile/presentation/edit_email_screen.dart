import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_textformfield.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/routing/navigation_bar_controller.dart';

class EditEmailScreen extends ConsumerStatefulWidget {
  const EditEmailScreen({super.key});

  @override
  ConsumerState<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends ConsumerState<EditEmailScreen> {
  final TextEditingController _editEmailController = TextEditingController();
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
                  ref
                      .read(navigationBarControllerProvider.notifier)
                      .showNavBar();
                  context.pop();
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ThemeColor.primaryColor,
              )),
          title: const Text('Ganti Email'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTextField(
            controller: _editEmailController,
            labelText: 'Email',
            hintText: 'john_doe@email.com',
          ),
        ),
      ),
    );
  }
}
