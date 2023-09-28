import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_textformfield.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/strings.dart';
import 'package:mobile/src/constants/theme_colors.dart';

class EditPasswordScreen extends ConsumerStatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  ConsumerState<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends ConsumerState<EditPasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isCurrentTextObscure = true;
  bool _isNewTextObscure = true;

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
          child: Column(
            children: [
              CustomTextField(
                controller: _currentPasswordController,
                labelText: 'Password Sekarang',
                obscureText: _isCurrentTextObscure,
                toggleObscureText: () {
                  setState(() {
                    _isCurrentTextObscure = !_isCurrentTextObscure;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (!value.isValidPassword) {
                    return 'Password harus mengandung setidaknya satu huruf besar, satu huruf kecil, satu angka, satu karakter khusus, dan memiliki panjang minimal 8 karakter';
                  }
                  return null;
                },
              ),
              gapH16,
              CustomTextField(
                controller: _newPasswordController,
                labelText: 'Password Baru',
                obscureText: _isNewTextObscure,
                toggleObscureText: () {
                  setState(() {
                    _isNewTextObscure = !_isNewTextObscure;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (!value.isValidPassword) {
                    return 'Password harus mengandung setidaknya satu huruf besar, satu huruf kecil, satu angka, satu karakter khusus, dan memiliki panjang minimal 8 karakter';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
