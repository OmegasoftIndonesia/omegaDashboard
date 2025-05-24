import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? ctrl;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry padding;
  final void Function()? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.ctrl,
    this.hintText,
    this.keyboardType,
    this.validator,
    required this.obscureText,
    required this.padding,
    this.onTap,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: ctrl,
        showCursor: true,
        onTap: onTap,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF5F6F8)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF5F6F8)),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF5F6F8)),
          ),
          filled: true,
          fillColor: const Color(Constants.appAccentColor),
          hintStyle: const TextStyle(
            color: Color(0xFF9e9e9e),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
