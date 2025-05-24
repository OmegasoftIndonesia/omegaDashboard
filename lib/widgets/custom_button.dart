import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String textButton;
  final bool? isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    required this.textButton,
    this.onPressed,
    this.isLoading,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: widget.foregroundColor,
            backgroundColor: widget.backgroundColor,
          ),
          child: widget.isLoading ?? false
              ? const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                )
              : Text(
                  widget.textButton,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
