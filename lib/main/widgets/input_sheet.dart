import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputSheet {
  static show(BuildContext context,
      {String title,
      String placeholder,
      TextEditingController editController,
      Function(String) inputHandler,
      Function() completeHandler,
      bool excessButton = false,
      Function() excessHandler}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: HalfWidthContainer(
                  content: AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.fromLTRB(15, 40, 15, 10),
                      backgroundColor: Colors.transparent,
                      content: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            color: Colours.bg_color,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyles.naviTitle,
                                    ),
                                    CupertinoButton(
                                        padding: EdgeInsets.all(10),
                                        child: LoadAssetImage('dapp/dapp_close',
                                            width: 24),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                ),
                                Gaps.vGap10,
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  child: Container(
                                      color: Colours.bg_gray,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: CupertinoTextField(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 12, 10, 12),
                                            controller: editController,
                                            cursorHeight: 18,
                                            placeholder: placeholder,
                                            decoration: null,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[a-zA-Z]|[0-9]")),
                                              LengthLimitingTextInputFormatter(
                                                  12)
                                            ],
                                            cursorColor: Colours.app_main,
                                            style: TextStyles
                                                .token_transfer_address,
                                            placeholderStyle:
                                                TextStyles.password_place,
                                            onChanged: (String textInput) {
                                              inputHandler(textInput);
                                            },
                                          )),
                                          excessButton
                                              ? CupertinoButton(
                                                  padding: EdgeInsets.fromLTRB(
                                                      30, 10, 30, 10),
                                                  minSize: 30,
                                                  child: LoadAssetImage(
                                                    "dapp/dapp_scan",
                                                    width: 20,
                                                  ),
                                                  onPressed: () {
                                                    excessHandler();
                                                  })
                                              : SizedBox(),
                                        ],
                                      )),
                                ),
                                Gaps.vGap20,
                                Container(
                                    width: Screen.width,
                                    child: CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        minSize: 30,
                                        color: Colours.app_main,
                                        child: Text(
                                          S.of(context).confirm,
                                          style: TextStyles.dapp_sheet_button,
                                        ),
                                        onPressed: () {
                                          completeHandler();
                                        }))
                              ],
                            ),
                          )))));
        });
  }
}
