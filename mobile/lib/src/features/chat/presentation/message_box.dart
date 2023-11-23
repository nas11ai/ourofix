import 'package:flutter/material.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';

class MessageBox extends StatelessWidget {
  final String text;
  final String senderName;
  final bool isSender;
  final bool isFirstItem;

  const MessageBox({
    Key? key,
    required this.text,
    required this.senderName,
    required this.isSender,
    required this.isFirstItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender ? Colors.grey.shade400 : ThemeColor.primaryColor;
    final textColor =
        isSender ? ThemeColor.primaryColor : ThemeColor.tertiaryColor;

    return Padding(
      padding: isSender
          ? isFirstItem
              ? const EdgeInsets.only(
                  right: Sizes.p48,
                  left: Sizes.p16,
                )
              : const EdgeInsets.only(
                  right: Sizes.p48,
                  left: Sizes.p16,
                  top: Sizes.p16,
                )
          : isFirstItem
              ? const EdgeInsets.only(
                  left: Sizes.p48,
                  right: Sizes.p16,
                )
              : const EdgeInsets.only(
                  left: Sizes.p48,
                  right: Sizes.p16,
                  top: Sizes.p16,
                ),
      child: Align(
        alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
        child: Card(
          color: bgColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
