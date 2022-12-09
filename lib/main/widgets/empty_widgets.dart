import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/material.dart';

class EmptyWidgets {
  static Widget listEmpty(String emptyTitle) {
    return Container(
        padding: EdgeInsets.only(top: 50),
        width: Screen.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LoadAssetImage(
              "common/nodata",
              width: 70,
            ),
            Gaps.vGap15,
            Text(
              emptyTitle,
              style: TextStyle(
                fontSize: 13,
                color: Colours.text_gray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ));
  }
}
