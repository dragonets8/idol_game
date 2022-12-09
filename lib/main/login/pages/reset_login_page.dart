import 'package:country_calling_code_picker/picker.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/login/models/send_code_entity.dart';
import 'package:idol_game/main/login/widgets/country_picker.dart';
import 'package:idol_game/main/login/widgets/login_segment.dart';
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
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/valid_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';

class ResetLoginPage extends StatefulWidget {
  ResetLoginPage() : super();
  @override
  ResetLoginState createState() => ResetLoginState();
}

class ResetLoginState extends State<ResetLoginPage> {
  int currrentIndex = 0;
  String userName = "";
  String passcode = "";
  String password = "";
  String repassword = "";
  TextEditingController userController = TextEditingController(text: "");
  TextEditingController codeController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController repasswordController = TextEditingController(text: "");

  Country selectedCountry = Country("China", "flags/chn.png", "CN", "+86");

  @override
  void initState() {
    super.initState();
  }

  selectCountry() {
    NavigatorUtils.pushTransparentPage(context,
        CountryPicker(selectCountry: (country) {
      setState(() {
        selectedCountry = country;
      });
    }));
  }

  sendCode() async {
    if (userName == "") {
      EasyLoading.showToast("Please enter mobile or email");
      return;
    }
    String phone = currrentIndex == 0 ? userName : "";
    String email = currrentIndex == 0 ? "" : userName;
    String countryCode = currrentIndex == 0
        ? selectedCountry.callingCode.replaceAll("+", "")
        : "";
    Map<String, dynamic> sendCodeParama = {
      "type": "$currrentIndex",
      "email": email,
      "phone": phone,
      "countryCode": countryCode
    };
    DioManager().request<SendCodeEntity>(Apis.sendCode, params: sendCodeParama,
        success: (data) {
      print(data.code);
    }, error: (error) {
      print(error.message);
    });
  }

  reset() async {
    if (!ValidUtils.isPassword(password)) {
      EasyLoading.showToast(S.of(context).password_format_tips);
      return;
    }
    if (password != repassword) {
      EasyLoading.showToast(S.of(context).inconsistent_password);
      return;
    }
    String phone = currrentIndex == 0 ? userName : "";
    String email = currrentIndex == 0 ? "" : userName;
    String countryCode = currrentIndex == 0
        ? selectedCountry.callingCode.replaceAll("+", "")
        : "";
    Map<String, dynamic> resetParama = {
      "type": "$currrentIndex",
      "email": email,
      "phone": phone,
      "countryCode": countryCode,
      "password": password,
      "passwordTemp": repassword,
      "validCode": passcode
    };
    DioManager().request<dynamic>(Apis.modifyPass, params: resetParama,
        success: (data) {
      Navigator.of(context).pop();
      EasyLoading.showToast(S.of(context).successfully);
    }, error: (error) {
      print(error.message);
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
                    child: SingleChildScrollView(
                        child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(
                        title: S.of(context).reset_login_password,
                      ),
                      Container(
                        height: 50,
                        child: LoginSegment(
                          titles: [
                            S.of(context).via_mobile,
                            S.of(context).via_email
                          ],
                          segmentChange: (index) {
                            setState(() {
                              currrentIndex = index;
                              userName = "";
                              passcode = "";
                              password = "";
                              repassword = "";
                              userController.text = "";
                              codeController.text = "";
                              passwordController.text = "";
                              repasswordController.text = "";
                            });
                          },
                        ),
                      ),
                      Gaps.vGap10,
                      Container(
                        height: 190,
                        child: resetWidget(),
                      ),
                      Buttons.stateButton(
                          title: S.of(context).reset,
                          enable: userName != "" &&
                              passcode != "" &&
                              password != "" &&
                              repassword != "",
                          click: () {
                            reset();
                          }),
                    ],
                  ),
                ))))));
  }

  Widget resetWidget() {
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: 60,
                child: currrentIndex == 0
                    ? countryCodeWidget()
                    : Text(S.of(context).email_title,
                        style: TextStyles.my_setting_title)),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 35,
                  color: Colours.bg_dark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: CupertinoTextField(
                        controller: userController,
                        cursorHeight: 20,
                        keyboardType: currrentIndex == 0
                            ? TextInputType.number
                            : TextInputType.emailAddress,
                        placeholder: currrentIndex == 0
                            ? S.of(context).phone_placeholder
                            : S.of(context).email_placeholder,
                        placeholderStyle: TextStyles.token_receive_address,
                        decoration: null,
                        cursorColor: Colours.app_main,
                        style: TextStyles.my_setting_title,
                        onChanged: (String textInput) {
                          setState(() {
                            userName = textInput;
                          });
                        },
                      )),
                      LoginFormCode(
                          available: userName != "",
                          onTapCallback: () {
                            sendCode();
                          }),
                      Gaps.hGap10
                    ],
                  )),
            ))
          ],
        ),
        Gaps.vGap10,
        Row(
          children: [
            Container(
                width: 60,
                child: Text(
                  S.of(context).code_title,
                  style: TextStyles.my_setting_title,
                )),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 35,
                  width: 120,
                  color: Colours.bg_dark,
                  child: CupertinoTextField(
                    controller: codeController,
                    cursorHeight: 20,
                    keyboardType: TextInputType.number,
                    placeholder: S.of(context).code_placeholder,
                    placeholderStyle: TextStyles.token_receive_address,
                    decoration: null,
                    cursorColor: Colours.app_main,
                    style: TextStyles.my_setting_title,
                    onChanged: (String textInput) {
                      setState(() {
                        passcode = textInput;
                      });
                    },
                  )),
            ))
          ],
        ),
        Gaps.vGap10,
        Row(
          children: [
            Container(
                width: 60,
                child: Text(
                  S.of(context).password_title,
                  style: TextStyles.my_setting_title,
                )),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 35,
                  width: 120,
                  color: Colours.bg_dark,
                  child: CupertinoTextField(
                    controller: passwordController,
                    cursorHeight: 20,
                    obscureText: true,
                    inputFormatters: AuthSheet.passwordFormatter,
                    placeholder: S.of(context).password_placeholder,
                    placeholderStyle: TextStyles.token_receive_address,
                    decoration: null,
                    cursorColor: Colours.app_main,
                    style: TextStyles.my_setting_title,
                    onChanged: (String textInput) {
                      setState(() {
                        password = textInput;
                      });
                    },
                  )),
            ))
          ],
        ),
        Gaps.vGap10,
        Row(
          children: [
            Container(
                width: 60,
                child: Text(
                  S.of(context).repassword_title,
                  style: TextStyles.my_setting_title,
                )),
            Gaps.hGap20,
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                  height: 35,
                  width: 120,
                  color: Colours.bg_dark,
                  child: CupertinoTextField(
                    controller: repasswordController,
                    cursorHeight: 20,
                    obscureText: true,
                    inputFormatters: AuthSheet.passwordFormatter,
                    placeholder: S.of(context).repassword_placeholder,
                    placeholderStyle: TextStyles.token_receive_address,
                    decoration: null,
                    cursorColor: Colours.app_main,
                    style: TextStyles.my_setting_title,
                    onChanged: (String textInput) {
                      setState(() {
                        repassword = textInput;
                      });
                    },
                  )),
            ))
          ],
        )
      ],
    );
  }

  Widget countryCodeWidget() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          selectCountry();
        },
        child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
            child: Container(
                alignment: AlignmentDirectional.center,
                height: 35,
                width: 60,
                color: Colours.bg_dark,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    selectedCountry.callingCode,
                    style: TextStyles.my_setting_title,
                  ),
                  Gaps.hGap5,
                  LoadAssetImage(
                    "wallet/arrow_down",
                    color: Colors.white,
                    width: 10,
                  ),
                ]))));
  }
}
