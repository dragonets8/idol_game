import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:flutter/services.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthSheet {
  static List<TextInputFormatter> passwordFormatter = [
    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]|[0-9]")),
    LengthLimitingTextInputFormatter(20),
  ];

  static verify(BuildContext context, bool isLogin,
      {Function(String) inputHandler, Function() completeHandler}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: HalfWidthContainer(
                  content: AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.fromLTRB(15, 50, 15, 0),
                      backgroundColor: Colors.transparent,
                      content: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
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
                                      isLogin
                                          ? S.of(context).verify_login_password
                                          : S.of(context).verify_password,
                                      style: TextStyles.naviTitle,
                                    ),
                                    CupertinoButton(
                                        padding: EdgeInsets.all(10),
                                        minSize: 20,
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
                                      child: CupertinoTextField(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 12, 10, 12),
                                        cursorHeight: 18,
                                        placeholder: isLogin
                                            ? S
                                                .of(context)
                                                .enter_login_password_tips
                                            : S.of(context).enter_password_tips,
                                        obscureText: true,
                                        decoration: null,
                                        inputFormatters: passwordFormatter,
                                        cursorColor: Colours.app_main,
                                        style:
                                            TextStyles.token_transfer_address,
                                        placeholderStyle:
                                            TextStyles.password_place,
                                        onChanged: (String textInput) {
                                          inputHandler(textInput);
                                        },
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

  static set(BuildContext context,
      {Function(String) newPassHandler,
      Function(String) rePassHandler,
      Function() completeHandler}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: HalfWidthContainer(
                  content: AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.fromLTRB(15, 50, 15, 10),
                      backgroundColor: Colors.transparent,
                      content: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          child: Container(
                            height: 230,
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                            color: Colours.bg_color,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).set_password,
                                        style: TextStyles.naviTitle),
                                    CupertinoButton(
                                        padding: EdgeInsets.all(10),
                                        minSize: 20,
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
                                      child: CupertinoTextField(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 12, 10, 12),
                                        cursorHeight: 20,
                                        placeholder:
                                            S.of(context).new_password_tips,
                                        decoration: null,
                                        obscureText: true,
                                        inputFormatters: passwordFormatter,
                                        cursorColor: Colours.app_main,
                                        style:
                                            TextStyles.token_transfer_address,
                                        placeholderStyle:
                                            TextStyles.password_place,
                                        onChanged: (String textInput) {
                                          newPassHandler(textInput);
                                        },
                                      )),
                                ),
                                Gaps.vGap10,
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  child: Container(
                                      color: Colours.bg_gray,
                                      child: CupertinoTextField(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 12, 10, 12),
                                        cursorHeight: 20,
                                        placeholder:
                                            S.of(context).re_password_tips,
                                        decoration: null,
                                        obscureText: true,
                                        inputFormatters: passwordFormatter,
                                        cursorColor: Colours.app_main,
                                        style:
                                            TextStyles.token_transfer_address,
                                        placeholderStyle:
                                            TextStyles.password_place,
                                        onChanged: (String textInput) {
                                          rePassHandler(textInput);
                                        },
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
