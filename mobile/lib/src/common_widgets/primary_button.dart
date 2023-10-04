import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.svgImage,
    this.isOutlined = false,
  });
  final String text;
  final bool isLoading;
  final bool isOutlined;
  final SvgPicture? svgImage;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : ThemeColor.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: isOutlined
                  ? const BorderSide(color: ThemeColor.primaryColor)
                  : BorderSide.none),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: isOutlined
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (svgImage != null) svgImage!,
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: isOutlined
                        ? Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: ThemeColor.primaryColor,
                            )
                        : Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                  ),
                  if (svgImage != null) gapW16,
                ],
              ),
      ),
    );
  }
}
