import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/pages/mnemonic_verify_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/tips_sheet.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/wallet_hd.dart';
import 'package:flutter/cupertino.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web3dart/crypto.dart';

class MnemonicGeneratePage extends StatefulWidget {
  MnemonicGeneratePage({Key key}) : super(key: key);

  @override
  MnemonicGenerateState createState() => MnemonicGenerateState();
}

class MnemonicGenerateState extends State<MnemonicGeneratePage> {
  List<String> mnemonicList = [];

  verifyMnemonic() {
    EasyLoading.show();
    String mnemonic = mnemonicList.join(" ");
    getPrivateKey(mnemonic).then((privateKey) {
      WalletHd.getAccountAddress(mnemonic).then((addressMap) {
        EasyLoading.dismiss();
        print("BTC地址：${addressMap["BTC"]}，ETH地址：${addressMap["ETH"]}");
        NavigatorUtils.pushTransparentPage(
            context,
            MnemonicVerifyPage(
                mnemonic: mnemonic,
                privateKey: privateKey,
                addressMap: addressMap));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    generateMnemonic();
    Future.delayed(Duration(milliseconds: 200), () {
      showBottomSheet();
    });
  }

  generateMnemonic() {
    String mnemonic = bip39.generateMnemonic();
    setState(() {
      mnemonicList = mnemonic.split(" ");
    });
  }

  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child1 = root.derivePath("m/44'/60'/0'/0/0");
    return bytesToHex(child1.privateKey);
  }

  showBottomSheet() {
    TipsSheet.show(context,
        title: S.of(context).important_tips,
        content: S.of(context).mnemonic_tips_content,
        sheetAction: () {});
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
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 0), // 四周填充边距32像素
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NaviBar(title: S.of(context).generate_mnemonic),
                      Gaps.vGap10,
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mnemonicList.length,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.7,
                        ),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  color: Colours.bg_dark,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${index + 1}",
                                          style: TextStyles.guide_mnem_index,
                                        ),
                                        Gaps.vGap3,
                                        Text(mnemonicList[index],
                                            style: TextStyles.guide_mnem_select)
                                      ])));
                        },
                      ),
                      Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: CupertinoButton(
                              minSize: 30,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                S.of(context).regenerate_mnemonic,
                                style: TextStyles.transmit_hash,
                              ),
                              onPressed: () {
                                generateMnemonic();
                              })),
                      Gaps.vGap8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                                  minSize: 30,
                                  color: Colours.bg_dark,
                                  child: Text(
                                    S.of(context).backuped,
                                    style: TextStyles.wallet_guide_button,
                                  ),
                                  onPressed: () {
                                    EasyLoading.show();
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      verifyMnemonic();
                                    });
                                  })),
                        ],
                      ),
                    ],
                  ),
                )))));
  }
}
