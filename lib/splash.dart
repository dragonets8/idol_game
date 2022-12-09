import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/main/dapp/pages/web3_view.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating/floating/floating.dart';

class SplashPage extends StatefulWidget {
  static String initJs;
  static String walletJs;

  SplashPage() : super();
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  Floating xwgFloating;
  bool isOpening = false;

  @override
  void initState() {
    super.initState();
    loadJsFile(["init.js", "alpha.js"]).then((jsList) {
      SplashPage.initJs = jsList[0];
      SplashPage.walletJs = jsList[1];
      Future.delayed(Duration(milliseconds: 1000), () {
        openDreamCardGame();
      });
    });
  }

  Future<List<String>> loadJsFile(List<String> jsPath) async {
    var initJsText = await rootBundle.loadString('assets/js/${jsPath[0]}');
    var walletJsText = await rootBundle.loadString('assets/js/${jsPath[1]}');
    return [initJsText, walletJsText];
  }

  openDreamCardGame() {
    WalletDB().queryWalletActivity((queryData) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Web3View(
                  dapp: GameConfig.idolDapp,
                  initialUrl: GameConfig.idolDapp.url,
                  address:
                      queryData.length == 0 ? "" : queryData.first["smart"],
                  smartChain: ChainConfig.bep20,
                  isFullscreen: false)),
          (route) => route == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: CupertinoPageScaffold(
            backgroundColor: Color(0XFF060001),
            child:
                Center(child: LoadAssetImage('common/xwg_logo', width: 80))));
  }
}
