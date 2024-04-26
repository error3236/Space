import 'package:flash/Themes/app_colors.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  final controller;
  final FocusNode? focusNode;
  final String hintText;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.hintText,
     this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: const Border(top: BorderSide(color: AppColors.grey))),
      child: TextField(
       
        focusNode: focusNode,
        scrollPadding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? AppColors.secondary
                    : Colors.grey),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            fillColor: AppColors.primary,
            filled: true,
            hintText: hintText),
      ),
    );
  }
}
