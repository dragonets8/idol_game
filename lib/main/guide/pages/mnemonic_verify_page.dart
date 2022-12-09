import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/database/wallet_entity.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/models/guide_utils.dart';
import 'package:idol_game/main/guide/models/random_mnemonic.dart';
import 'package:idol_game/main/widgets/buttons.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/tips_sheet.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MnemonicVerifyPage extends StatefulWidget {
  MnemonicVerifyPage({Key key, this.mnemonic, this.privateKey, this.addressMap})
      : super(key: key);

  final String mnemonic;
  final String privateKey;
  final Map<String, String> addressMap;
  @override
  MnemonicVerifyState createState() => MnemonicVerifyState();
}

class MnemonicVerifyState extends State<MnemonicVerifyPage> {
  List<String> correctMnemonic = [];
  List<RandomMnemonic> randomMnemonic = [];
  List<String> selectMnemonic = [];
  String privateKey = "";
  String btcAddress = "";
  String smartAddress = "";
  String inputPassword = "";
  String newPassword = "";
  String rePassword = "";

  @override
  void initState() {
    super.initState();
    getCorrectMnemonic();
  }

  gotoHome() {
    WalletEntity wallet = WalletEntity(
        name: "wallet",
        private: privateKey,
        btc: btcAddress,
        smart: smartAddress,
        type: 1,
        active: 1,
        time: DateTime.now().microsecondsSinceEpoch);
    GuideUtils.gotoHome(context, wallet, SecurityUtils.currentPassword);
  }

  createWalletSuccess() {
    WalletDB().queryWalletWithType(1, (queryData) {
      print(queryData);
      if (queryData.length > 0) {
        SecurityUtils.showAuth(context, alwaysNeed: true,
            unlockHandler: (privateKey) {
          gotoHome();
        });
      } else {
        TipsSheet.show(context,
            title: S.of(context).important_tips,
            content: S.of(context).password_tips_content, sheetAction: () {
          SecurityUtils.setAuth(context, setHandler: () {
            gotoHome();
          });
        });
      }
    });
  }

  getCorrectMnemonic() {
    correctMnemonic = widget.mnemonic.split(" ");
    setRandomMnemonic();
    privateKey = widget.privateKey;
    btcAddress = widget.addressMap["BTC"];
    smartAddress = widget.addressMap["ETH"];
  }

  /// 从本地缓存中拿出上一步的助记词，准备初始化
  setRandomMnemonic() {
    List<String> tempMnemonic = correctMnemonic;
    setState(() {
      selectMnemonic.clear();
      randomMnemonic.clear();
      tempMnemonic.forEach((element) {
        randomMnemonic.add(RandomMnemonic(mnemonic: element, isSelect: false));
      });
      randomMnemonic.shuffle();
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
                        padding: const EdgeInsets.fromLTRB(
                            15, 5, 15, 0), // 四周填充边距32像素
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NaviBar(title: S.of(context).verify_mnemonic),
                              Gaps.vGap15,
                              Row(
                                children: [
                                  Expanded(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6.0),
                                          ),
                                          child: Container(
                                            color: Color(0xffdddde8),
                                            child: GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: randomMnemonic.length,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 8),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 8,
                                                crossAxisSpacing: 8,
                                                childAspectRatio: 2.3,
                                              ),
                                              itemBuilder: (context, index) {
                                                return selectItem(index);
                                              },
                                            ),
                                          ))),
                                  Gaps.hGap10,
                                  Expanded(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6.0),
                                          ),
                                          child: Container(
                                              color: Color(0xffffffff),
                                              child: GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    randomMnemonic.length,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 8,
                                                  crossAxisSpacing: 8,
                                                  childAspectRatio: 2.3,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return mnemonicItem(
                                                      randomMnemonic[index]);
                                                },
                                              )))),
                                ],
                              ),
                              Gaps.vGap20,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: CupertinoButton(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 8, 30, 8),
                                          minSize: 20,
                                          color: Colours.bg_gray,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Text(
                                            S.of(context).reset,
                                            style: TextStyles.nft_history_time,
                                          ),
                                          onPressed: () {
                                            setRandomMnemonic();
                                          })),
                                  Gaps.hGap10,
                                  Expanded(
                                    child: Buttons.halfStateButton(
                                        title: S.of(context).confirm,
                                        enable: selectMnemonic.join(" ") ==
                                            correctMnemonic.join(" "),
                                        click: () {
                                          createWalletSuccess();
                                        }),
                                  ),
                                ],
                              ),
                              Gaps.vGap20
                            ],
                          ),
                        ))))));
  }

  //构建每一个助记词
  Widget mnemonicItem(RandomMnemonic mnemonicItem) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          clickMnemonicItem(mnemonicItem);
        },
        child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
            child: Container(
                decoration: BoxDecoration(
                    color: mnemonicItem.isSelect
                        ? Colours.bg_color
                        : Colours.bg_dark,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(mnemonicItem.mnemonic,
                    style: mnemonicItem.isSelect
                        ? TextStyles.guide_mnem_select
                        : TextStyles.guide_mnem_title))));
  }

  //构建每一个助记词
  Widget selectItem(int selectItemIndex) {
    bool isSelect = selectItemIndex < selectMnemonic.length;
    String mnemonicString = isSelect ? selectMnemonic[selectItemIndex] : "";
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          isSelect ? clickSelectItem(mnemonicString) : null;
        },
        child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${selectItemIndex + 1} ",
                            style: TextStyles.guide_mnem_index,
                          ),
                          Text(mnemonicString,
                              style: TextStyles.dapp_tagtext_dark)
                        ],
                      ),
                    ]))));
  }

  clickMnemonicItem(RandomMnemonic mnemonicItem) {
    setState(() {
      if (!selectMnemonic.contains(mnemonicItem.mnemonic)) {
        selectMnemonic.add(mnemonicItem.mnemonic);
        mnemonicItem.isSelect = true;
      }
    });
    if (selectMnemonic.length == correctMnemonic.length) {
      if (selectMnemonic.join(" ") != correctMnemonic.join(" ")) {
        EasyLoading.showToast("Recovery Phrase order incorrect");
        setRandomMnemonic();
      }
    }
  }

  clickSelectItem(String mnemonicString) {
    setState(() {
      if (selectMnemonic.contains(mnemonicString)) {
        selectMnemonic.remove(mnemonicString);
        randomMnemonic
            .where((element) => element.mnemonic == mnemonicString)
            .toList()
            .first
            .isSelect = false;
      }
    });
  }
}
