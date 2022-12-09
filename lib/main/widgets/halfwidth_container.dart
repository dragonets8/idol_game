import 'package:idol_game/styles/screen.dart';
import 'package:flutter/material.dart';

class HalfWidthContainer extends StatelessWidget {
  const HalfWidthContainer({Key key, this.content}) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(right: Screen.width - Screen.height * 5 / 6),
        child: content,
      ),
    );
  }
}
