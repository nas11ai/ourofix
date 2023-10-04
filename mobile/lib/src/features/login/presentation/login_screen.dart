import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_textformfield.dart';
import 'package:mobile/src/common_widgets/primary_button.dart';
import 'package:mobile/src/common_widgets/responsive_center.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/strings.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/login/presentation/login_screen_controller.dart';
import 'package:mobile/src/routing/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);

    return Scaffold(
      body: ResponsiveCenter(
        maxContentWidth: 450,
        padding: const EdgeInsets.all(Sizes.p32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              gapH48,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      // Gaya teks umum (ukuran, dll.)
                      ),
                  children: const [
                    TextSpan(
                      text: 'Ayo kita ',
                      style: TextStyle(
                          color: ThemeColor
                              .primaryTextColor), // Atur warna teks yang berbeda
                    ),
                    TextSpan(
                      text: 'mulai!',
                      style: TextStyle(
                          color: ThemeColor
                              .secondaryColor), // Atur warna teks yang berbeda
                    ),
                  ],
                ),
              ),
              gapH16,
              Text(
                'Login agar bisa mengakses',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .merge(TextStyle(color: Colors.grey.shade700)),
                textAlign: TextAlign.center,
              ),
              gapH4,
              Text(
                'layanan dari Ourofix',
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
                        text: 'Login',
                        isLoading: state.isLoading,
                        isOutlined: false,
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
                                  context.goNamed(AppRoute.home.name);
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
              gapH32,
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                  Text('atau', style: TextStyle(color: Colors.grey)),
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              gapH32,
              PrimaryButton(
                isOutlined: true,
                text: 'Login dengan Google',
                svgImage: SvgPicture.asset(
                  'assets/icon/icons8-google.svg',
                  width: MediaQuery.sizeOf(context).width * 0.1,
                  height: MediaQuery.sizeOf(context).width * 0.1,
                ),
                onPressed: () {
                  if (context.mounted) {
                    context.goNamed(AppRoute.home.name);
                  }
                },
              ),
              gapH64,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun?',
                  ),
                  gapW4,
                  InkWell(
                    onTap: () {
                      // Aksi ketika teks "Daftar disini" diklik
                      context.goNamed(AppRoute.register.name);
                    },
                    child: const Text(
                      'Daftar disini',
                      style: TextStyle(
                        color: ThemeColor
                            .primaryColor, // Atur warna teks sesuai kebutuhan Anda
                        decoration: TextDecoration
                            .underline, // Memberi efek garis bawah pada teks
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
