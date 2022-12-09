import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/login/models/send_code_entity.dart';
import 'package:idol_game/main/login/widgets/verify_button.dart';
import 'package:idol_game/main/widgets/auth_sheet.dart';
import 'package:idol_game/main/widgets/buttons.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/encrypt_utils.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:idol_game/utils/valid_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';

class ChangeLoginPage extends StatefulWidget {
  ChangeLoginPage({Key key, this.userName}) : super(key: key);

  final String userName;
  @override
  ChangeLoginState createState() => ChangeLoginState();
}

class ChangeLoginState extends State<ChangeLoginPage> {
  String passcode = "";
  String oldPassword = "";
  String newPassword = "";
  String repeatPassword = "";

  @override
  void initState() {
    super.initState();
  }

  sendCode() async {
    bool isMobile = widget.userName.contains("&&");
    Map<String, dynamic> sendCodeParama = {
      "type": isMobile ? 0 : 1,
      "email": isMobile ? "" : widget.userName,
      "phone": isMobile ? widget.userName.split("&&")[1] : "",
      "countryCode": isMobile ? widget.userName.split("&&")[0] : ""
    };
    DioManager().request<SendCodeEntity>(Apis.sendCode, params: sendCodeParama,
        success: (data) {
      print(data.code);
    }, error: (error) {
      print(error.message);
    });
  }

  verifyPassword() async {
    if (!ValidUtils.isPassword(newPassword)) {
      EasyLoading.showToast(S.of(context).password_format_tips);
      return;
    }
    if (newPassword != repeatPassword) {
      EasyLoading.showToast(S.of(context).inconsistent_password);
      return;
    }
    SecurityUtils.passwordForPrivate(context, -1, oldPassword,
        (passed, private) {
      if (passed) {
        print(private);
        String newEncrypt = EncryptUtils.aesEncrypt(
            EncryptUtils.stringToKey(newPassword), private);
        changePassword(newEncrypt);
      } else {
        EasyLoading.showToast(S.of(context).verify_password_failed);
      }
    });
  }

  changePassword(String encryptPrivate) async {
    bool isMobile = widget.userName.contains("&&");
    Map<String, dynamic> changeParama = {
      "type": isMobile ? 0 : 1,
      "email": isMobile ? "" : widget.userName,
      "phone": isMobile ? widget.userName.split("&&")[1] : "",
      "countryCode": isMobile ? widget.userName.split("&&")[0] : "",
      "password": newPassword,
      "passwordTemp": repeatPassword,
      "validCode": passcode
    };
    DioManager().request<dynamic>(Apis.modifyPass, params: changeParama,
        success: (data) {
      changeLocalPrivate(encryptPrivate);
    }, error: (error) {
      print(error.message);
    });
  }

  changeLocalPrivate(String encryptPrivate) {
    WalletDB().queryWallet("active = 1", (walletData) async {
      WalletDB().updateWalletWith(walletData.first["id"], encryptPrivate);
      Navigator.of(context).pop();
      EasyLoading.showToast(S.of(context).successfully);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HalfWidthContainer(
            content: CupertinoPageScaffold(
                backgroundColor: Colours.bg_color,
                child: SafeArea(
                    child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NaviBar(
                        title: S.of(context).change_login_password,
                      ),
                      Container(
                        height: 300,
                        child: changeWidget(),
                      ),
                      Buttons.stateButton(
                          title: S.of(context).confirm,
                          enable: passcode != "" &&
                              oldPassword != "" &&
                              newPassword != "" &&
                              repeatPassword != "",
                          click: () {
                            verifyPassword();
                          }),
                    ],
                  ),
                )))));
  }

  Widget changeWidget() {
    return Column(
      children: [
        Gaps.vGap15,
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              child: Text(widget.userName.replaceAll("&&", "-"),
                  style: TextStyles.my_username)),
          Gaps.hGap15,
          LoginFormCode(
              available: true,
              onTapCallback: () {
                sendCode();
              }),
        ]),
        Gaps.vGap32,
        Row(
          children: [
            Container(
                width: 70,
                child: Text(
                  S.of(context).code_title,
                  style: TextStyles.my_title,
                )),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 40,
                  width: 120,
                  color: Colours.bg_dark,
                  child: CupertinoTextField(
                    cursorHeight: 20,
                    keyboardType: TextInputType.number,
                    placeholder: S.of(context).code_placeholder,
                    placeholderStyle: TextStyles.token_receive_address,
                    decoration: null,
                    cursorColor: Colours.app_main,
                    style: TextStyles.my_title,
                    onChanged: (String textInput) {
                      setState(() {
                        passcode = textInput;
                      });
                    },
                  )),
            ))
          ],
        ),
        Gaps.vGap15,
        Row(
          children: [
            Container(
                width: 70,
                child: Text(
                  S.of(context).old_password_title,
                  style: TextStyles.my_title,
                )),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 40,
                  width: 120,
                  color: Colours.bg_dark,
                  child: CupertinoTextField(
                    cursorHeight: 20,
                    obscureText: true,
                    placeholder: S.of(context).old_password_placeholder,
                    placeholderStyle: TextStyles.token_receive_address,
                    decoration: null,
                    cursorColor: Colours.app_main,
                    style: TextStyles.my_title,
                    onChanged: (String textInput) {
                      setState(() {
                        oldPassword = textInput;
                      });
                    },
                  )),
            ))
          ],
        ),
        Gaps.vGap15,
        Row(
          children: [
            Container(
                width: 70,
                child: Text(
                  S.of(context).new_password_title,
                  style: TextStyles.my_title,
                )),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 40,
                  width: 120,
                  color: Colours.bg_dark,
                  child: CupertinoTextField(
                    cursorHeight: 20,
                    obscureText: true,
                    inputFormatters: AuthSheet.passwordFormatter,
                    placeholder: S.of(context).new_password_placeholder,
                    placeholderStyle: TextStyles.token_receive_address,
                    decoration: null,
                    cursorColor: Colours.app_main,
                    style: TextStyles.my_title,
                    onChanged: (String textInput) {
                      setState(() {
                        newPassword = textInput;
                      });
                    },
                  )),
            ))
          ],
        ),
        Gaps.vGap15,
        Row(
          children: [
            Container(
                width: 70,
                child: Text(
                  S.of(context).repassword_title,
                  style: TextStyles.my_title,
                )),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 40,
                  width: 120,
                  color: Colours.bg_dark,
                  child: CupertinoTextField(
                    cursorHeight: 20,
                    obscureText: true,
                    inputFormatters: AuthSheet.passwordFormatter,
                    placeholder: S.of(context).repassword_placeholder,
                    placeholderStyle: TextStyles.token_receive_address,
                    decoration: null,
                    cursorColor: Colours.app_main,
                    style: TextStyles.my_title,
                    onChanged: (String textInput) {
                      setState(() {
                        repeatPassword = textInput;
                      });
                    },
                  )),
            ))
          ],
        )
      ],
    );
  }
}
