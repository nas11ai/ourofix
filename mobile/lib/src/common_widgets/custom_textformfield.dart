import 'package:flutter/material.dart';
import 'package:mobile/src/constants/theme_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function()? toggleObscureText; // Callback untuk toggle obscureText

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.toggleObscureText, // Tambahkan parameter ini
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: ThemeColor.primaryColor),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: obscureText
            ? GestureDetector(
                onTap: () {
                  if (toggleObscureText != null) {
                    toggleObscureText!(); // Panggil callback untuk toggle
                  }
                },
                child: const Icon(Icons.visibility_off),
              )
            : suffixIcon != null
                ? Icon(suffixIcon)
                : null,
        iconColor: ThemeColor.primaryColor,
        labelStyle: const TextStyle(color: ThemeColor.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ThemeColor.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: ThemeColor.secondaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ThemeColor.errorColor,
          ),
        ),
      ),
    );
  }
}
