import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertSheet {
  static show(BuildContext context,
      {String title,
      String content,
      String actionTitle,
      String cancelTitle,
      Color actionColor,
      Function() actionHandler,
      Function() cancelHandler}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return HalfWidthContainer(
              content: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  insetPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  backgroundColor: Colors.transparent,
                  content: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      child: Container(
                        height: 135,
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        color: Colours.bg_color,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyles.naviTitle,
                            ),
                            Gaps.vGap15,
                            Text(
                              content,
                              style: TextStyles.alert_delete_content,
                            ),
                            Gaps.vGap20,
                            Row(
                              children: [
                                Expanded(
                                    child: CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 8, 30, 8),
                                        minSize: 20,
                                        color: Colours.text_disabled,
                                        child: Text(
                                          cancelTitle,
                                          style: TextStyle(
                                            color: Colours.dark_text_gray,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })),
                                Gaps.hGap20,
                                Expanded(
                                    child: CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 8, 30, 8),
                                        minSize: 20,
                                        color: Colours.red,
                                        child: Text(
                                          actionTitle,
                                          style: TextStyle(
                                            color: actionColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          actionHandler();
                                        }))
                              ],
                            )
                          ],
                        ),
                      ))));
        });
  }
}
