import 'package:flutter/material.dart';
import 'custom_container.dart';

class CustomContainerDashboard2 extends StatefulWidget {
  final String? cash;

  const CustomContainerDashboard2({super.key, this.cash});

  @override
  State<CustomContainerDashboard2> createState() =>
      _CustomContainerDashboard2State();
}

class _CustomContainerDashboard2State extends State<CustomContainerDashboard2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 10),
      child: CustomContainer(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            const Column(
              children: [
                Text(
                  "CASH",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "CREDIT CARD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "DEBIT CARD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "MERCHANT PAY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  widget.cash!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                 "0",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "0",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "0",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
