import 'package:country_calling_code_picker/picker.dart';
import 'package:idol_game/main/login/widgets/country_picker.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/database/wallet_entity.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/models/guide_utils.dart';
import 'package:idol_game/main/login/models/login_entity.dart';
import 'package:idol_game/main/login/pages/register_page.dart';
import 'package:idol_game/main/login/pages/register_success_page.dart';
import 'package:idol_game/main/login/pages/reset_login_page.dart';
import 'package:idol_game/main/login/widgets/login_segment.dart';
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
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/wallet_hd/config.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  int currrentIndex = 0;
  String userName = "";
  String password = "";
  TextEditingController userController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  Country selectedCountry = Country("China", "flags/chn.png", "CN", "+86");

  @override
  void initState() {
    super.initState();
  }

  openRegister() {
    NavigatorUtils.pushTransparentPage(context, RegisterPage());
  }

  openReset() {
    NavigatorUtils.pushTransparentPage(context, ResetLoginPage());
  }

  selectCountry() {
    NavigatorUtils.pushTransparentPage(context,
        CountryPicker(selectCountry: (country) {
      setState(() {
        selectedCountry = country;
      });
    }));
  }

  gotoHome(LoginEntity loginEntity) async {
    String keyStore = EncryptUtils.stringToKey(password);
    print(keyStore);
    String decrypted =
        EncryptUtils.aesDecrypt(keyStore, loginEntity.privateKey);
    WalletEntity wallet = WalletEntity(
        name: loginEntity.walletName,
        private: decrypted,
        btc: loginEntity.btcAddress,
        smart: loginEntity.smartAddress,
        type: 0,
        active: 1,
        time: DateTime.now().microsecondsSinceEpoch);
    GuideUtils.gotoHome(context, wallet, password);
  }

  login() async {
    String countryCode = currrentIndex == 0
        ? selectedCountry.callingCode.replaceAll("+", "")
        : "";
    String finalUsername =
        currrentIndex == 0 ? (countryCode + "&&" + userName) : userName;
    Map<String, dynamic> loginParama = {
      "username": finalUsername.replaceAll("&&", ""),
      "password": password,
    };
    DioManager().request<LoginEntity>(Apis.login, params: loginParama,
        success: (data) {
      print(data.privateKey);
      if (data.smartAddress == null) {
        NavigatorUtils.pushTransparentPage(context,
            RegisterSuccessPage(userName: userName, password: password));
      } else {
        gotoHome(data);
      }
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
                        title: S.of(context).login_title,
                        itemTitle: S.of(context).register_title,
                        itemClick: () {
                          openRegister();
                        },
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
                              password = "";
                              userController.text = "";
                              passwordController.text = "";
                            });
                          },
                        ),
                      ),
                      Gaps.vGap10,
                      Container(
                        height: 130,
                        child: loginWidget(),
                      ),
                      Buttons.stateButton(
                          title: S.of(context).login_title,
                          enable: userName != "" && password != "",
                          click: () {
                            login();
                          }),
                    ],
                  ),
                ))))));
  }

  Widget loginWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              openReset();
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Text(
                  S.of(context).forget_password,
                  textAlign: TextAlign.start,
                  style: TextStyles.token_transfer_all,
                )))
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
