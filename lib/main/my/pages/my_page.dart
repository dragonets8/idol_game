import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/my/models/my_entity.dart';
import 'package:idol_game/main/my/pages/security_page.dart';
import 'package:idol_game/main/my/pages/setting_page.dart';
import 'package:idol_game/main/my/widgets/my_cell.dart';
import 'package:idol_game/main/wallet/pages/wallet_list_page.dart';
import 'package:idol_game/services/storage_service.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';

class MyPage extends StatefulWidget {
  MyPage() : super();
  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  bool isLogin = false;
  String userName = "";

  @override
  void initState() {
    super.initState();
    refreshActiveWallet();
    bus.on("refreshActive", (args) {
      refreshActiveWallet();
    });
  }

  refreshActiveWallet() {
    WalletDB().queryWalletActivity((queryData) {
      if (queryData.first["type"] == 0) {
        setState(() {
          isLogin = true;
          userName = queryData.first["name"];
        });
      } else {
        setState(() {
          isLogin = false;
          userName = "";
        });
      }
    });
  }

  List<MyItem> getMyTitles() {
    return [
      MyItem(
        title: S.of(context).my_setting,
        image: "my/my_setting",
      ),
      MyItem(
        title: S.of(context).my_wallet,
        image: "my/my_wallet",
      ),
      MyItem(
        title: S.of(context).my_security,
        image: "my/my_safe",
      )
    ];
  }

  Widget myTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(userName.replaceAll("&&", ""), style: TextStyles.my_username),
    );
  }

  openMy(int itemIndex) {
    List myPages = [
      SettingPage(),
      WalletListPage(),
      SecurityPage(),
    ];
    if (itemIndex != 2) {
      NavigatorUtils.pushTransparentPage(context, myPages[itemIndex]);
    } else {
      bool bioEnable = StorageService.shared.getBool("bio") ?? false;
      LocalAuthentication auth = LocalAuthentication();
      auth.getAvailableBiometrics().then((biometricTypes) {
        NavigatorUtils.pushTransparentPage(context,
            SecurityPage(bioEnable: bioEnable, bioTypes: biometricTypes));
      });
    }
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
                        NaviBar(title: S.of(context).my),
                        Gaps.vGap10,
                        Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: getMyTitles().length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  return index == 0
                                      ? (isLogin ? myTitle() : SizedBox())
                                      : MyCell(
                                          itemIndex: index - 1,
                                          myItem: getMyTitles()[index - 1],
                                          myClick: (itemIndex) {
                                            openMy(itemIndex);
                                          });
                                }))
                      ]))),
        )));
  }
}
