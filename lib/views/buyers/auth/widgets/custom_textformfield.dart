import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool enabled;
  final Widget? suffix;
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: enabled,
        obscureText: obscureText,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please $labelText must not be empty';
            // return 'Please Enter $labelText';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
