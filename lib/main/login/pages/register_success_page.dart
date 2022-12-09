import 'package:idol_game/database/wallet_entity.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/models/guide_utils.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/encrypt_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:idol_game/wallet_hd/wallet_hd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web3dart/crypto.dart';

class RegisterSuccessPage extends StatefulWidget {
  RegisterSuccessPage({Key key, this.userName, this.password})
      : super(key: key);

  final String userName;
  final String password;

  @override
  RegisterSuccessState createState() => RegisterSuccessState();
}

class RegisterSuccessState extends State<RegisterSuccessPage> {
  String walletAddress = "";
  String private = "";

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: "Creating wallet ...");
    Future.delayed(Duration(milliseconds: 2000), () {
      generateMnemonic();
    });
  }

  generateMnemonic() {
    String mnemonic = bip39.generateMnemonic();
    getPrivateKey(mnemonic).then((privateKey) {
      private = privateKey;
      WalletHd.getAccountAddress(mnemonic).then((addressMap) {
        setState(() {
          walletAddress = addressMap["ETH"];
        });
        print("BTC地址：${addressMap["BTC"]}，ETH地址：${addressMap["ETH"]}");
        EasyLoading.showSuccess("Create wallet successfully");
      });
    });
  }

  gotoHome() async {
    WalletEntity wallet = WalletEntity(
        name: widget.userName,
        private: private,
        btc: "",
        smart: walletAddress,
        type: 0,
        active: 1,
        time: DateTime.now().microsecondsSinceEpoch);
    GuideUtils.gotoHome(context, wallet, widget.password);
  }

  bindWallet() async {
    Map<String, dynamic> bindParama = {
      "username": widget.userName.replaceAll("&&", ""),
      "walletName": widget.userName.replaceAll("&&", ""),
      "privateKey": EncryptUtils.aesEncrypt(
          EncryptUtils.stringToKey(widget.password), private),
      "btcAddress": "",
      "smartAddress": walletAddress,
      "walletType": "0"
    };
    DioManager().request<dynamic>(Apis.bindWallet, params: bindParama,
        success: (data) {
      gotoHome();
    }, error: (error) {
      print(error.message);
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
                    child: Container(
                  padding: const EdgeInsets.all(15.0), // 四周填充边距32像素
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NaviBar(title: S.of(context).create_wallet),
                      Gaps.vGap15,
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          color: Colours.bg_dark,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).wallet_name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: "D-DIN",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Gaps.vGap5,
                                  Text(
                                    widget.userName.replaceAll("&&", "") ?? "",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colours.bg_light,
                                      fontFamily: "D-DIN",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Gaps.vGap15,
                                  Text(
                                    S.of(context).wallet_address,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: "D-DIN",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Gaps.vGap5,
                                  Text(
                                    walletAddress,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colours.bg_light,
                                      fontFamily: "D-DIN",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                      Gaps.vGap24,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  minSize: 35,
                                  color: Colours.app_main,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: Text(
                                    S.of(context).confirm,
                                    style: TextStyles.wallet_guide_button,
                                  ),
                                  onPressed: () {
                                    bindWallet();
                                  })),
                        ],
                      ),
                    ],
                  ),
                )))));
  }
}
