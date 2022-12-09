import 'package:idol_game/main/wallet/pages/wallet_home_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/pages/wallet_guide_page.dart';
import 'package:idol_game/main/login/models/send_code_entity.dart';
import 'package:idol_game/main/login/widgets/verify_button.dart';
import 'package:idol_game/main/widgets/buttons.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/wallet_hd/config.dart';

class DeleteUserPage extends StatefulWidget {
  DeleteUserPage({Key key, this.wallet}) : super(key: key);

  final Map<String, dynamic> wallet;
  @override
  DeleteUserState createState() => DeleteUserState();
}

class DeleteUserState extends State<DeleteUserPage> {
  String passcode = "";

  @override
  void initState() {
    super.initState();
  }

  sendCode() async {
    String userName = widget.wallet["name"];
    bool isMobile = userName.contains("&&");
    Map<String, dynamic> sendCodeParama = {
      "type": isMobile ? 0 : 1,
      "email": isMobile ? "" : userName,
      "phone": isMobile ? userName.split("&&")[1] : "",
      "countryCode": isMobile ? userName.split("&&")[0] : ""
    };
    DioManager().request<SendCodeEntity>(Apis.sendCode, params: sendCodeParama,
        success: (data) {
      print(data.code);
    }, error: (error) {
      print(error.message);
    });
  }

  deleteUser() async {
    Map<String, dynamic> deleteParama = {
      "username": widget.wallet["name"].replaceAll("&&", ""),
      "validCode": passcode,
    };
    DioManager().request<dynamic>(Apis.deleteUser, params: deleteParama,
        success: (data) {
      if (widget.wallet["active"] == 1) {
        WalletDB().deleteWallet(widget.wallet["id"], () {
          WalletDB().queryWallet("id > 0", (queryData) {
            if (queryData.length > 0) {
              WalletDB().activeWallet(queryData[0]["id"]);
              bus.emit("switch_wallet");
              bus.emit("refresh_wallet_list");
              bus.emit("refreshActive");
              bus.emit("switchWeb3Wallet");
              Navigator.of(context).popUntil((route) => route.isFirst);
              NavigatorUtils.pushTransparentPage(context, WalletHomePage());
            } else {
              Navigator.of(context).popUntil((route) => route.isFirst);
              NavigatorUtils.pushTransparentPage(
                  context, WalletGuidePage(isRoot: true));
            }
          });
        });
      } else {
        WalletDB().deleteWallet(widget.wallet["id"], () {
          bus.emit("switch_wallet");
          bus.emit("refresh_wallet_list");
          Navigator.of(context).popUntil((route) => route.isFirst);
          NavigatorUtils.pushTransparentPage(context, WalletHomePage());
        });
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
                    child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NaviBar(
                        title: S.of(context).delete_user_title,
                      ),
                      Container(
                        height: 140,
                        child: changeWidget(),
                      ),
                      Buttons.stateButton(
                          title: S.of(context).confirm,
                          enable: passcode != "",
                          click: () {
                            deleteUser();
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
              child: Text(widget.wallet["name"].replaceAll("&&", "-"),
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
        )
      ],
    );
  }
}
