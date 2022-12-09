import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/styles.dart';

class LoginSegment extends StatefulWidget {
  LoginSegment({Key key, this.titles, this.segmentChange}) : super(key: key);

  final List<String> titles;
  final Function(int) segmentChange;

  @override
  LoginSegmentState createState() => LoginSegmentState();
}

class LoginSegmentState extends State<LoginSegment> {
  int currrentIndex = 0;

  clickSegment(int segIndex) {
    widget.segmentChange(segIndex);
    setState(() {
      currrentIndex = segIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              clickSegment(0);
            },
            child: Text(widget.titles[0],
                style: currrentIndex == 0
                    ? TextStyles.login_seg2
                    : TextStyles.login_seg1)),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              clickSegment(1);
            },
            child: Text(widget.titles[1],
                style: currrentIndex == 0
                    ? TextStyles.login_seg1
                    : TextStyles.login_seg2)),
      ],
    );
  }
}
