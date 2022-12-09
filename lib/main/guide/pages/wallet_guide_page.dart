import 'package:idol_game/main/wallet/pages/wallet_home_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/pages/import_mnemonic_page.dart';
import 'package:idol_game/main/guide/pages/import_privatekey_page.dart';
import 'package:idol_game/main/guide/pages/mnemonic_generate_page.dart';
import 'package:idol_game/main/login/pages/login_page.dart';
import 'package:idol_game/main/widgets/single_select_sheet.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class WalletGuidePage extends StatefulWidget {
  WalletGuidePage({Key key, this.isRoot}) : super(key: key);

  final bool isRoot;
  @override
  WalletGuideState createState() => WalletGuideState();
}

class WalletGuideState extends State<WalletGuidePage> {
  DateTime lastPopTime;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    WalletDB().queryWalletWithType(0, (queryData) {
      setState(() {
        isLogin = queryData.length > 0;
      });
    });
  }

  List<String> filterImages = [
    "guide/import_privatekey",
    "guide/import_mnemonic"
  ];

  registerLogin() {
    NavigatorUtils.pushTransparentPage(context, LoginPage());
  }

  createWallet() {
    NavigatorUtils.pushTransparentPage(context, MnemonicGeneratePage());
  }

  importWallet() {
    SingleSelectSheet.show(
        context,
        S.of(context).import_wallet,
        [S.of(context).privatekey_import, S.of(context).mnemonic_import],
        filterImages,
        -1, (sheetIndex) {
      NavigatorUtils.pushTransparentPage(context,
          sheetIndex == 0 ? ImportPrivatekeyPage() : ImportMnemonicPage());
    });
  }

  createWalletSuccess() {
    NavigatorUtils.pushTransparentPage(context, WalletHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: HalfWidthContainer(
                content: CupertinoPageScaffold(
                    backgroundColor: Colours.bg_color,
                    child: SafeArea(
                        child: Center(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                          Gaps.vGap10,
                          widget.isRoot
                              ? SizedBox()
                              : CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child:
                                      LoadAssetImage('common/back', width: 25),
                                  onPressed: () =>
                                      {Navigator.of(context).pop()}),
                          Gaps.vGap32,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                isLogin ? SizedBox() : guideItem(0),
                                isLogin ? SizedBox() : Gaps.vGap10,
                                guideItem(1),
                                Gaps.vGap10,
                                guideItem(2),
                              ],
                            ),
                          )
                        ])))))),
        onWillPop: () async {
          if (!widget.isRoot) {
            return true;
          } else if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            EasyLoading.showToast(S.of(context).close_tips);
            return false;
          } else {
            lastPopTime = DateTime.now();
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return false;
          }
        });
  }

  Widget guideItem(int itemIndex) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (itemIndex == 0) {
            registerLogin();
          }
          if (itemIndex == 1) {
            createWallet();
          }
          if (itemIndex == 2) {
            importWallet();
          }
        },
        child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                width: Screen.height * 5 / 6 - 30,
                height: 50,
                color: Colours.bg_dark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LoadAssetImage(
                        itemIndex < 2
                            ? "guide/wallet_create"
                            : "guide/wallet_import",
                        width: 25),
                    Gaps.hGap10,
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            [
                              S.of(context).regist_login_title,
                              S.of(context).create_wallet,
                              S.of(context).import_wallet
                            ][itemIndex],
                            style: TextStyles.my_title,
                          ),
                          Text(
                            [
                              S.of(context).regist_login_tips,
                              S.of(context).create_wallet_tips,
                              S.of(context).import_wallet_tips
                            ][itemIndex],
                            style: TextStyles.wallet_guide_desc,
                          )
                        ]),
                  ],
                ))));
  }
}
