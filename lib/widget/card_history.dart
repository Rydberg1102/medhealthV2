import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:medhealth/network/model/history_model.dart';
import 'package:medhealth/theme.dart';

class CardHistory extends StatelessWidget {
  final HistoryOrderModel model;
  CardHistory({required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "INV/" + model.invoice,
              style: boldTextStyle.copyWith(fontSize: 16),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
            )
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          model.orderAt,
          style: regularTextStyle.copyWith(fontSize: 16),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          model.status == "1" ? "Orders are being confirmed" : "Order Success",
          style: lightTextStyle,
        ),
        Divider()
      ],
    );
  }
}
