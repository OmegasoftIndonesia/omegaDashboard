import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  const CustomContainer(
      {super.key, this.width, this.height, this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(Constants.colorBackgroundContainer),
      ),
      child: child,
    );
  }
}
