import 'package:flutter/material.dart';

class CustomTextFormFieldDate extends StatelessWidget {
  final TextEditingController? ctrl;
  final String? hintText;
  final bool obscureText;
  final bool isSmallerPhone;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry padding;
  final void Function()? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;

  const CustomTextFormFieldDate({
    super.key,
    this.ctrl,
    this.hintText,
    this.keyboardType,
    this.validator,
    required this.obscureText,
    required this.padding,
    this.onTap,
    required this.readOnly,
    required this.isSmallerPhone,
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
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmallerPhone ? 12 : 14,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          hintStyle: const TextStyle(
            color: Color(0xFF9e9e9e),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          hintText: hintText,
        ),
      ),
    );
  }
}
