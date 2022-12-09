import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/database/wallet_entity.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/models/guide_utils.dart';
import 'package:idol_game/main/widgets/buttons.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/qrcode_scanner.dart';
import 'package:idol_game/main/widgets/tips_sheet.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:idol_game/utils/valid_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web3dart/web3dart.dart';

class ImportPrivatekeyPage extends StatefulWidget {
  ImportPrivatekeyPage() : super();
  @override
  ImportPrivatekeyState createState() => ImportPrivatekeyState();
}

class ImportPrivatekeyState extends State<ImportPrivatekeyPage> {
  String inputString = "";
  String inputPassword = "";
  String newPassword = "";
  String rePassword = "";
  TextEditingController privateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      privateController.text = inputString;
    });
  }

  gotoHome(Map<String, String> addressMap) async {
    String privateKey = inputString;
    WalletEntity wallet = WalletEntity(
        name: "wallet",
        private: privateKey,
        btc: addressMap["BTC"],
        smart: addressMap["ETH"],
        type: 2,
        active: 1,
        time: DateTime.now().microsecondsSinceEpoch);
    GuideUtils.gotoHome(context, wallet, SecurityUtils.currentPassword);
  }

  importPrivatekey() async {
    FocusScope.of(context).unfocus();
    EasyLoading.show();
    Map<String, String> addressMap = {};
    EthPrivateKey ethPrivateKey = EthPrivateKey.fromHex(inputString);
    EthereumAddress ethAddr = await ethPrivateKey.extractAddress();
    addressMap = {"BTC": "", "ETH": ethAddr.toString()};
    setPasscode(addressMap);
    print("BTC地址：${addressMap["BTC"]}，ETH地址：${addressMap["ETH"]}");
  }

  setPasscode(Map<String, String> addressMap) {
    WalletDB().queryWalletWithType(1, (queryData) {
      if (queryData.length > 0) {
        WalletDB().queryWalletWithAddress(addressMap["ETH"], (addressData) {
          if (addressData.length > 0) {
            EasyLoading.showToast(S.of(context).wallet_already_exist);
          } else {
            SecurityUtils.showAuth(context, alwaysNeed: true,
                unlockHandler: (privateKey) {
              gotoHome(addressMap);
            });
          }
        });
      } else {
        TipsSheet.show(context,
            title: S.of(context).important_tips,
            content: S.of(context).password_tips_content, sheetAction: () {
          SecurityUtils.setAuth(context, setHandler: () {
            gotoHome(addressMap);
          });
        });
      }
      EasyLoading.dismiss();
    });
  }

  scanQrcode() async {
    FocusScope.of(context).unfocus();
    Future.delayed(Duration(milliseconds: 200), () {
      NavigatorUtils.pushTransparentPage(context,
          QRCodeScanner(scanComplete: (qrcode) {
        setState(() {
          inputString = qrcode;
          privateController.text = qrcode;
        });
      }));
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
                    children: <Widget>[
                      NaviBar(
                        title: S.of(context).privatekey_import,
                        // itemImage: "dapp/dapp_scan",
                        itemClick: () {
                          scanQrcode();
                        },
                      ),
                      Gaps.vGap20,
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        child: Container(
                            height: 120,
                            padding: EdgeInsets.all(5),
                            color: Colours.text_gray,
                            child: CupertinoTextField(
                              textAlignVertical: TextAlignVertical.top,
                              controller: privateController,
                              cursorHeight: 20,
                              autofocus: true,
                              placeholder:
                                  S.of(context).import_privatekey_placeholder,
                              decoration: null,
                              maxLines: 5,
                              cursorColor: Colours.app_main,
                              style: TextStyles.token_name,
                              onChanged: (String textInput) {
                                setState(() {
                                  inputString = textInput;
                                });
                              },
                            )),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Buttons.stateButton(
                          title: S.of(context).import_wallet,
                          enable: ValidUtils.isPrivateKey(inputString),
                          click: () {
                            importPrivatekey();
                          }),
                    ],
                  ),
                ))))));
  }
}
