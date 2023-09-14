import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_textformfield.dart';
import 'package:mobile/src/common_widgets/primary_button.dart';
import 'package:mobile/src/common_widgets/responsive_center.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/strings.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/login/presentation/login_screen_controller.dart';
import 'package:mobile/src/routing/app_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);

    // Future<void> handleLogin(BuildContext context) async {
    //   if (_loginForm.currentState!.validate()) {
    //     final username = _usernameController.text;
    //     final password = _passwordController.text;

    //     try {
    //       // Call the login method from your repository
    //       await loginRepository.login(username, password);

    //       // Successful login, navigate to the next screen or perform other actions
    //       // context.goNamed(AppRoute.home.name);
    //     } catch (e) {
    //       // Handle login errors, e.g., display an error message
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Login failed. Please check your credentials.'),
    //         ),
    //       );
    //     }
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoute.login.name),
        ),
      ),
      body: ResponsiveCenter(
        maxContentWidth: 450,
        padding: const EdgeInsets.all(Sizes.p32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              gapH32,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      // Gaya teks umum (ukuran, dll.)
                      ),
                  children: const [
                    TextSpan(
                      text: 'Sign ',
                      style: TextStyle(
                          color: ThemeColor
                              .primaryTextColor), // Atur warna teks yang berbeda
                    ),
                    TextSpan(
                      text: 'Up',
                      style: TextStyle(
                          color: ThemeColor
                              .secondaryColor), // Atur warna teks yang berbeda
                    ),
                  ],
                ),
              ),
              gapH16,
              Text(
                'Daftarkan akunmu untuk',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .merge(TextStyle(color: Colors.grey.shade700)),
                textAlign: TextAlign.center,
              ),
              gapH4,
              Text(
                'bisa mengakses layanan kami',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .merge(TextStyle(color: Colors.grey.shade700)),
                textAlign: TextAlign.center,
              ),
              gapH64,
              Form(
                key: _loginForm,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      labelText: 'Username',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    gapH16,
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!(value.isValidEmail)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    gapH16,
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: _isObscureText,
                      toggleObscureText: () {
                        setState(() {
                          _isObscureText = !_isObscureText;
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
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Register',
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                await ref
                                    .read(loginControllerProvider.notifier)
                                    .handleLogin(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                    );
                                if (context.mounted) {
                                  // go to sign in page after completing onboarding
                                  context.goNamed(AppRoute.login.name);
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
              gapH64,
            ],
          ),
        ),
      ),
    );
  }
}
