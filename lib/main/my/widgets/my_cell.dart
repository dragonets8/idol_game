import 'package:idol_game/main/my/models/my_entity.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class MyCell extends StatelessWidget {
  const MyCell({Key key, this.itemIndex, this.myItem, this.myClick})
      : super(key: key);

  final int itemIndex;
  final MyItem myItem;
  final Function(int) myClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          myClick(itemIndex);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  LoadAssetImage(myItem.image, width: 24),
                  Gaps.hGap20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myItem.title,
                        style: TextStyles.my_title,
                      ),
                    ],
                  ),
                ]),
              ],
            )));
  }
}
