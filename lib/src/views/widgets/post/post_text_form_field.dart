import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostTextFormField extends StatelessWidget {
  final String? text;

  late final bool isEnabled;
  late final bool isOptional;
  late final bool isNumber;
  late final TextEditingController controller;

  PostTextFormField(
      // this.text,
      this.controller,
      {this.isEnabled = true,
      this.isOptional = false,
      this.isNumber = false,
      this.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      enabled: isEnabled,
      textAlign: TextAlign.start,
      validator: (value) {
        if (value!.isEmpty) {
          if (isOptional) {
            return null;
          }
          return 'field must not be empty!';
        }
      },
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          isDense: true,
          fillColor: Colors.grey.withOpacity(0.2),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          hintText: text != null ? '$text' : '',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8))),
    );
  }
}
