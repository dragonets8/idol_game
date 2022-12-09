import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/pages/wallet_home_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WalletPasswordPage extends StatefulWidget {
  WalletPasswordPage() : super();
  @override
  WalletPasswordState createState() => WalletPasswordState();
}

class WalletPasswordState extends State<WalletPasswordPage> {
  String newPassword, rePassword = "12345678";

  createWalletSuccess() {
    NavigatorUtils.pushTransparentPage(context, WalletHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HalfWidthContainer(
            content: CupertinoPageScaffold(
          backgroundColor: Colours.bg_color,
          child: SafeArea(
              child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              passwordTextField(),
              SizedBox(height: 20.0),
              repasswordTextField(),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: CupertinoButton(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          color: Colours.text_gray,
                          child: Text(
                            S.of(context).previous,
                            style: TextStyles.wallet_guide_button,
                          ),
                          onPressed: () {
                            bus.emit("guidetab", [2]);
                          })),
                  SizedBox(
                    width: 60,
                  ),
                  Expanded(
                      child: CupertinoButton(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          color: Colours.app_main,
                          child: Text(
                            S.of(context).confirm,
                            style: TextStyles.wallet_guide_button,
                          ),
                          onPressed: () {
                            createWallet();
                          })),
                ],
              )
            ],
          )),
        )));
  }

  createWallet() {
    EasyLoading.show();
    Future.delayed(const Duration(milliseconds: 800), () {
      createWalletSuccess();
      EasyLoading.dismiss();
    });
    if (newPassword == rePassword &&
        !newPassword.isEmpty &&
        newPassword.length >= 8 &&
        newPassword.length <= 20) {
      // Navigator.of(context).pop(newPassword);
    } else {
      if (newPassword.isEmpty || rePassword.isEmpty) {
      } else {
        String val = '';
        if (newPassword.length < 8) {
          val = '长度必须大于等于8位';
        } else if (newPassword.length > 20) {
          val = '长度必须小于等于20位';
        } else {
          val = '两次输入密码不同';
        }
      }
    }
  }

  Widget passwordTextField() {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          color: Colors.white,
          child: CupertinoTextField(
            cursorHeight: 20,
            placeholder: S.of(context).password_tips,
            decoration: null,
            maxLines: 1,
            cursorColor: Colours.app_main,
            style: TextStyles.token_name,
            onChanged: (String textInput) {},
          )),
    );
  }

  Widget repasswordTextField() {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          color: Colors.white,
          child: CupertinoTextField(
            cursorHeight: 20,
            placeholder: S.of(context).repassword_tips,
            decoration: null,
            maxLines: 1,
            cursorColor: Colours.app_main,
            style: TextStyles.token_name,
            onChanged: (String textInput) {},
          )),
    );
  }
}
