import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medhealth/theme.dart';

class CardProduct extends StatelessWidget {
  final String imageProduct;
  final String nameProduct;
  final String price;
  CardProduct(
      {required this.imageProduct,
      required this.nameProduct,
      required this.price});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat("###0.00", "EN_US");
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(
            imageProduct,
            width: 115,
            height: 76,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            nameProduct,
            style: regularTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            "RM" + priceFormat.format(double.parse(price)),
            style: boldTextStyle,
          )
        ],
      ),
    );
  }
}
