import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class TextFormFieldWidget extends StatelessWidget {
  late final TextEditingController controller;
  final bool isPassword;
  final Widget? suffixIcon;

  TextFormFieldWidget(
      {required this.controller, this.suffixIcon, this.isPassword = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        obscureText: isPassword,
        style: Components.kBodyOne(context)
            ?.copyWith(fontWeight: FontWeight.normal),
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field cannot be empty';
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          isDense: true,
          fillColor: Colors.grey.withOpacity(0.2),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          suffixIcon: suffixIcon,
        ),
      ),
    );
    //hey you can do that directly
  }
}
