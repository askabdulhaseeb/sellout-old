import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    Key? key,
    required this.controller,
    this.suffixIcon,
    this.isPassword = false,
  }) : super(key: key);
  final TextEditingController controller;
  final bool isPassword;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: (_width > 300) ? 350 : _width,
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
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
    //hey you can do that directly
  }
}
