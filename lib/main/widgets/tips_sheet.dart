import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TipsSheet {
  static show(BuildContext context,
      {String title, String content, Function() sheetAction}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0))),
        builder: (BuildContext context) {
          return AnimatedPadding(
              //showModalBottomSheet 键盘弹出时自适应
              padding: MediaQuery.of(context).viewInsets, //边距（必要）
              duration: const Duration(milliseconds: 100), //时长 （必要）
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15, right: Screen.width - Screen.height * 5 / 6 + 15),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 60, //设置最小高度（必要）
                    maxHeight:
                        MediaQuery.of(context).size.height * 0.9, //设置最大高度（必要）
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      color: Colours.bg_color), //圆角
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true, //防止状态溢出 自适应大小
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Gaps.vGap12,
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              content,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colours.text_gray,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                              width: Screen.width - 40,
                              child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  minSize: 30,
                                  color: Colours.app_main,
                                  child: Text(
                                    S.of(context).confirm,
                                    style: TextStyles.dapp_sheet_button,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    sheetAction();
                                  })),
                          Gaps.vGap18
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
