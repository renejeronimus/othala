import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:othala/themes/theme_data.dart';

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton({
    Key? key,
    required this.textLabel,
    this.buttonColor = kYellowColor,
    this.fontColor = kDarkBackgroundColor,
    this.enabled = true,
  }) : super(key: key);

  final Color buttonColor;
  final Color fontColor;
  final String textLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    double _opacity = 1.0;
    enabled == false ? _opacity = 0.2 : _opacity = 1.0;

    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(28.0),
        color: buttonColor.withOpacity(_opacity),
      ),
      child: Text(
        textLabel,
        style: TextStyle(
            color: fontColor, fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
    );
  }
}
