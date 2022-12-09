import 'package:idol_game/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomWidgets {
  static Widget refreshHeader(double size) {
    return Container(
        width: size,
        height: size,
        child: LoadingIndicator(
            colors: const [Colours.app_main],
            indicatorType: Indicator.ballPulse,
            strokeWidth: 2,
            pathBackgroundColor: Colors.black));
  }
}
