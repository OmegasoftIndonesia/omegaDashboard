import 'dart:ffi';

import 'package:flutter/material.dart';
import 'custom_container.dart';

class CustomContainerDashboard2 extends StatefulWidget {
  final String? cash;
  final String? kredit;
  final String? debit;
  final String? merchant;
  final String? discountAfterTax;
  final String? klaim;
  final String? title;
  const CustomContainerDashboard2({super.key, this.cash, this.debit,this.kredit, this.merchant, this.klaim,this.discountAfterTax, this.title});

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                (widget.cash! != "Rp. 0")?Text(
                  "CASH",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ):SizedBox(),
                (widget.kredit! != "Rp. 0")? Text(
                  "CREDIT CARD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ):SizedBox(),
                (widget.debit! != "Rp. 0")? Text(
                  "DEBIT CARD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ):SizedBox(),
                (widget.merchant! != "Rp. 0")? Text(
                  "MERCHANT PAY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),

                ):SizedBox(),
                (widget.klaim! != "Rp. 0")?Text(
                  "KLAIM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),

                ):SizedBox(),
                (widget.discountAfterTax! != "Rp. 0")?Text(
                  "DISCOUNT AFTER TAX",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ):SizedBox()
              ],
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.cash! != "Rp. 0")?Text(
                    widget.cash!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ):SizedBox(),
                  (widget.kredit! != "Rp. 0")?Text(
                   widget.kredit!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ):SizedBox(),
                  (widget.debit! != "Rp. 0")?Text(
                    widget.debit!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ):SizedBox(),
                  (widget.merchant! != "Rp. 0")?Text(
                    widget.merchant!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ):SizedBox(),
                  (widget.klaim! != "Rp. 0")?Text(
                    widget.klaim!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ):SizedBox(),
                  (widget.discountAfterTax! != "Rp. 0")?Text(
                    widget.discountAfterTax!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
