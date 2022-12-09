import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/login/pages/change_login_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/tips_sheet.dart';
import 'package:idol_game/services/storage_service.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:local_auth/local_auth.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key key, this.bioEnable, this.bioTypes}) : super(key: key);

  final bool bioEnable;
  final List<BiometricType> bioTypes;

  @override
  SecurityState createState() => SecurityState();
}

class SecurityState extends State<SecurityPage> {
  bool isLogin = false;
  String userName = "";
  String passwordTitle = "";
  final bioController = AdvancedSwitchController();

  @override
  void initState() {
    super.initState();
    WalletDB().queryWalletActivity((queryData) {
      setState(() {
        isLogin = queryData.first["type"] == 0;
        userName = isLogin ? queryData.first["name"] : "";
        passwordTitle = queryData.first["type"] == 0
            ? S.of(context).change_login_password
            : S.of(context).change_passcode;
      });
    });
    setState(() {
      bioController.value = widget.bioEnable;
    });
    bioController.addListener(() {
      StorageService.shared.setBool("bio", bioController.value);
    });
  }

  changeAuth() {
    TipsSheet.show(context,
        title: S.of(context).important_tips,
        content: S.of(context).password_tips_content, sheetAction: () {
      SecurityUtils.showAuth(context, alwaysNeed: true,
          unlockHandler: (privateKey) {
        print(privateKey);
        SecurityUtils.setAuth(context,
            oldPrivate: privateKey, setHandler: () {});
      });
    });
  }

  changeLogin() {
    NavigatorUtils.pushTransparentPage(
        context, ChangeLoginPage(userName: userName));
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
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: S.of(context).my_security),
                      Gaps.vGap20,
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: Screen.width - 30,
                              height: 45,
                              color: Colours.bg_dark,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: passcodeItem(passwordTitle, () {
                                      isLogin ? changeLogin() : changeAuth();
                                    })),
                                  ])))
                    ],
                  ),
                )))));
  }

  String getBioTitle() {
    if (widget.bioTypes.length > 0) {
      if (widget.bioTypes[0] == BiometricType.face) {
        return S.of(context).faceid;
      } else if (widget.bioTypes[0] == BiometricType.fingerprint) {
        return S.of(context).fingerprint;
      }
    }
    return "";
  }

  Widget bioLockItem() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getBioTitle(),
              style: TextStyles.my_setting_title,
            ),
            AdvancedSwitch(
              controller: bioController,
              activeColor: Colours.app_main,
              inactiveColor: Colours.line,
              borderRadius: BorderRadius.all(const Radius.circular(12.5)),
              width: 45.0,
              height: 25.0,
              enabled: true,
              disabledOpacity: 0.5,
            )
          ],
        )));
  }

  Widget passcodeItem(String title, Function() clickAction) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          clickAction();
        },
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.my_setting_title,
            ),
            LoadAssetImage("my/more_arrow", width: 20)
          ],
        )));
  }
}
