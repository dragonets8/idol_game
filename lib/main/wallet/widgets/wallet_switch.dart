import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/widgets/wallet_cell.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WalletSwitch {
  static sheet(
    BuildContext context,
    List<Map<String, dynamic>> wallets,
    Function() walletManagerAction,
    Function() walletAddAction,
  ) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.fromLTRB(
                  15, 0, Screen.width - Screen.height * 5 / 6 + 15, 0),
              child: AnimatedPadding(
                //showModalBottomSheet 键盘弹出时自适应
                padding: MediaQuery.of(context).viewInsets, //边距（必要）
                duration: const Duration(milliseconds: 100), //时常 （必要）
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 60, //设置最小高度（必要）
                    maxHeight:
                        MediaQuery.of(context).size.height * 0.75, //设置最大高度（必要）
                  ),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      color: Colours.bg_color), //圆角
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true, //防止状态溢出 自适应大小
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CupertinoButton(
                                  child: LoadAssetImage(
                                    "wallet/wallet_manager",
                                    width: 18,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    walletManagerAction();
                                  }),
                              Text(
                                S.of(context).wallet_list,
                                style: TextStyles.naviTitle,
                              ),
                              CupertinoButton(
                                  child: LoadAssetImage(
                                    "wallet/wallet_add",
                                    width: 18,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    walletAddAction();
                                  })
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: wallets.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SwitchWalletCell(
                                        wallet: wallets[index],
                                        walletClick: () {
                                          switchWallet(context, wallets[index]);
                                        });
                                  })),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  static switchWallet(BuildContext context, Map<String, dynamic> wallet) {
    if (wallet["active"] == 0) {
      WalletDB().activeWallet(wallet["id"]);
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 500), () {
        bus.emit("switch_wallet");
        bus.emit("switchWeb3Wallet");
      });
      print(wallet["smart"]);
    } else {
      Navigator.of(context).pop();
    }
  }
}
