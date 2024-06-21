import 'package:flutter/material.dart';
import 'package:medhealth/theme.dart';

class WidgetIlustration extends StatelessWidget {
  final Widget child;
  final String image;
  final String title;
  final String subtitle1;
  final String subtitle2;
  WidgetIlustration(
      {this.child = const SizedBox.shrink(), // Default to an empty widget
      required this.image,
      required this.title,
      required this.subtitle1,
      required this.subtitle2});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 250,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          title,
          style: regularTextStyle.copyWith(fontSize: 25),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Column(
          children: [
            Text(
              subtitle1,
              style: regularTextStyle.copyWith(
                  fontSize: 15, color: greyLightColor),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              subtitle2,
              style: regularTextStyle.copyWith(
                  fontSize: 15, color: greyLightColor),
            ),
            SizedBox(
              height: 40,
            ),
            child,
          ],
        ),
      ],
    );
  }
}
