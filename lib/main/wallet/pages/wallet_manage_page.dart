import 'package:idol_game/main/widgets/alert_sheet.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/models/guide_utils.dart';
import 'package:idol_game/main/widgets/input_sheet.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WalletManagePage extends StatefulWidget {
  WalletManagePage({Key key, this.wallet}) : super(key: key);

  final Map<String, dynamic> wallet;
  @override
  WalletManageState createState() => WalletManageState();
}

class WalletManageState extends State<WalletManagePage> {
  String walletName = "";
  bool isLogin = false;
  String deleteTitle = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        walletName = widget.wallet["name"];
        isLogin = widget.wallet["type"] == 0;
        deleteTitle =
            isLogin ? S.of(context).logout_title : S.of(context).wallet_delete;
      });
    });
  }

  renameWallet() {
    InputSheet.show(context,
        title: S.of(context).wallet_change_name,
        placeholder: S.of(context).wallet_name_tips, inputHandler: (input) {
      walletName = input;
    }, completeHandler: () {
      if (walletName != "") {
        Navigator.of(context).pop();
        WalletDB().renameWallet(widget.wallet["id"], walletName);
        setState(() {
          walletName = walletName;
        });
        GuideUtils.bindAddress(
            widget.wallet["smart"], walletName, widget.wallet["type"]);
        bus.emit("switch_wallet");
        bus.emit("refresh_wallet_list");
      } else {
        EasyLoading.showToast(S.of(context).wallet_name_tips);
      }
    }, excessButton: false);
  }

  deleteWallet() {
    WalletDB().queryWallet("id > 0", (queryData) {
      if (queryData.length > 1) {
        AlertSheet.show(context,
            title: widget.wallet["type"] == 0
                ? "${S.of(context).logout_title} ${walletName.replaceAll("&&", "")} ?"
                : "${S.of(context).delete} $walletName?",
            content: S.of(context).wallet_delete_tips,
            actionTitle: widget.wallet["type"] == 0
                ? S.of(context).logout_title
                : S.of(context).delete,
            cancelTitle: S.of(context).cancel,
            actionColor: Colors.white, actionHandler: () {
          if (widget.wallet["active"] == 1) {
            WalletDB().deleteWallet(widget.wallet["id"], () {
              WalletDB().queryWallet("id > 0", (queryData) {
                WalletDB().activeWallet(queryData[0]["id"]);
                bus.emit("switch_wallet");
                bus.emit("refresh_wallet_list");
                bus.emit("refreshActive");
                bus.emit("switchWeb3Wallet");
                Navigator.of(context).pop();
              });
            });
          } else {
            WalletDB().deleteWallet(widget.wallet["id"], () {
              bus.emit("switch_wallet");
              bus.emit("refresh_wallet_list");
              bus.emit("switchWeb3Wallet");
              Navigator.of(context).pop();
            });
          }
        });
      } else {
        EasyLoading.showToast("This is your only wallet!");
      }
    });
  }

  showPrivateKey(String private) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return HalfWidthContainer(
              content: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  insetPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  backgroundColor: Colors.transparent,
                  content: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      child: Container(
                        height: 160,
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        color: Colours.bg_color,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).privatekey_import_tips,
                                  style: TextStyles.naviTitle,
                                ),
                                CupertinoButton(
                                    padding: EdgeInsets.all(5),
                                    child: LoadAssetImage('dapp/dapp_close',
                                        width: 24),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            ),
                            Gaps.vGap8,
                            Text(
                              private,
                              style: TextStyles.alert_delete_content,
                            ),
                            Gaps.vGap15,
                            Row(
                              children: [
                                Expanded(
                                    child: CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 8, 30, 8),
                                        minSize: 20,
                                        color: Colours.dark_text,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Text(
                                          S.of(context).cancel,
                                          style: TextStyles.dapp_sheet_button,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })),
                                Gaps.hGap20,
                                Expanded(
                                    child: CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 8, 30, 8),
                                        minSize: 20,
                                        color: Colours.app_main,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Text(
                                          S.of(context).copy,
                                          style: TextStyles.dapp_sheet_button,
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(
                                              ClipboardData(text: private));
                                          EasyLoading.showToast(
                                              "Copy successfully");
                                        })),
                              ],
                            )
                          ],
                        ),
                      ))));
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
                    children: [
                      NaviBar(title: walletName.replaceAll("&&", "")),
                      Gaps.vGap20,
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: Screen.width - 30,
                              height: isLogin ? 46 : 90,
                              color: Colours.bg_dark,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    isLogin
                                        ? SizedBox()
                                        : Expanded(child: renameItem()),
                                    isLogin
                                        ? SizedBox()
                                        : Container(
                                            color: Colours.line,
                                            height: 0.8,
                                          ),
                                    Expanded(child: privateItem()),
                                  ]))),
                      Gaps.vGap24,
                      Container(
                          width: Screen.height * 5 / 6,
                          child: CupertinoButton(
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                              minSize: 35,
                              color: Colours.app_main,
                              child: Text(
                                deleteTitle,
                                style: TextStyles.dapp_sheet_button,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              onPressed: () {
                                deleteWallet();
                              }))
                    ],
                  ),
                ))))));
  }

  Widget renameItem() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          renameWallet();
        },
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).wallet_change_name,
              style: TextStyles.my_setting_title,
            ),
            LoadAssetImage("my/more_arrow", width: 20),
          ],
        )));
  }

  Widget privateItem() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          SecurityUtils.showAuth(context,
              alwaysNeed: true,
              walletId: widget.wallet["id"], unlockHandler: (privateKey) {
            showPrivateKey(privateKey);
          });
        },
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).wallet_show_privatekey,
              style: TextStyles.my_setting_title,
            ),
            LoadAssetImage("my/more_arrow", width: 20),
          ],
        )));
  }
}
