import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/pages/wallet_manage_page.dart';
import 'package:idol_game/main/wallet/widgets/wallet_cell.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WalletListPage extends StatefulWidget {
  WalletListPage() : super();
  @override
  WalletListState createState() => WalletListState();
}

class WalletListState extends State<WalletListPage> {
  List<Map<String, dynamic>> wallets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWalletList();
      bus.on("refresh_wallet_list", (args) {
        getWalletList();
      });
    });
  }

  gotoManageWallet(Map<String, dynamic> wallet) {
    NavigatorUtils.pushTransparentPage(
        context, WalletManagePage(wallet: wallet));
  }

  getWalletList() {
    EasyLoading.show();
    WalletDB().queryWallet("id > 0", (queryData) {
      setState(() {
        wallets = queryData;
      });
      EasyLoading.dismiss();
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: S.of(context).wallet_list),
                      Gaps.vGap10,
                      Expanded(
                          child: ListView.builder(
                              itemCount: wallets.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ManageWalletCell(
                                    wallet: wallets[index],
                                    walletClick: () {
                                      print(wallets[index]["private"]);
                                      gotoManageWallet(wallets[index]);
                                    });
                              }))
                    ],
                  ),
                )))));
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color,
      ),
      child: Icon(
        icon,
        size: 18,
        color: Colors.white,
      ),
    );
  }
}
