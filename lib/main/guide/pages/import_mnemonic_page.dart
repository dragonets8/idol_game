import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/database/wallet_entity.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/models/guide_utils.dart';
import 'package:idol_game/main/widgets/buttons.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/tips_sheet.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:idol_game/wallet_hd/wallet_hd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web3dart/crypto.dart';

class ImportMnemonicPage extends StatefulWidget {
  ImportMnemonicPage() : super();
  @override
  ImportMnemonicState createState() => ImportMnemonicState();
}

class ImportMnemonicState extends State<ImportMnemonicPage> {
  String inputString = "";
  String inputPassword = "";
  String newPassword = "";
  String rePassword = "";

  @override
  void initState() {
    super.initState();
  }

  gotoHome(Map<String, String> addressMap) async {
    String mnemonic = inputString;
    String privateKey = await getPrivateKey(mnemonic);
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

  importMnemonic() async {
    FocusScope.of(context).unfocus();
    EasyLoading.show();
    Map<String, String> addressMap = {};
    WalletHd.getAccountAddress(inputString).then((accountAddress) {
      addressMap = accountAddress;
      setPasscode(addressMap);
    });
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

  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child1 = root.derivePath("m/44'/60'/0'/0/0");
    return bytesToHex(child1.privateKey);
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
                      NaviBar(title: S.of(context).mnemonic_import),
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
                              cursorHeight: 20,
                              placeholder:
                                  S.of(context).import_mnemonic_placeholder,
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
                          enable: inputString.length > 20,
                          click: () {
                            importMnemonic();
                          }),
                    ],
                  ),
                ))))));
  }
}
