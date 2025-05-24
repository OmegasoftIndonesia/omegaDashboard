import 'package:flutter/material.dart';
import 'custom_container.dart';

class CustomContainerDashboard extends StatefulWidget {
  final String nominal;
  final String title;
  final String? subtitle;

  const CustomContainerDashboard({
    super.key,
    required this.nominal,
    required this.title,
    this.subtitle,
  });

  @override
  State<CustomContainerDashboard> createState() =>
      _CustomContainerDashboardState();
}

class _CustomContainerDashboardState extends State<CustomContainerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 10),
      child: CustomContainer(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              widget.nominal,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              indent: 50,
              endIndent: 50,
              thickness: 1,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            if (widget.subtitle != null)
              Text(
                widget.subtitle!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
          ],
        ),
      ),
    );
  }
}
