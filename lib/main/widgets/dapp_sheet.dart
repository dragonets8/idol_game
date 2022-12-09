import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/main/dapp/models/dapp_transaction.dart';
import 'package:idol_game/main/widgets/transfer_sheet.dart';
import 'package:idol_game/provider/locale_provider.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DappSheet {
  static openDapp(BuildContext context,
      {bool isInfo = false, DappConf dapp, Function() clickAction}) {
    showSheetWithContent(context,
        content: DappContent.detail(dapp),
        title: isInfo
            ? S.of(context).dapp_about +
                " ${LocaleProvider().localeIndex > 0 ? dapp.nameCn : dapp.nameEn}"
            : S.of(context).dapp_open,
        buttonTitle: isInfo ? S.of(context).confirm : S.of(context).confirm,
        sheetAction: () {
      clickAction();
    }, cancelAction: () {});
  }

  static signMessage(BuildContext context,
      {String message, Function() clickAction, Function() cancelAction}) {
    showSheetWithContent(context,
        content: DappContent.signMessage(message),
        title: S.of(context).sign_message,
        buttonTitle: S.of(context).confirm,
        autoDismiss: false, sheetAction: () {
      clickAction();
    }, cancelAction: () {
      cancelAction();
    });
  }

  static signTransaction(BuildContext context,
      {DappTransaction transaction,
      Function() clickAction,
      Function() cancelAction}) {
    showSheetWithContent(context,
        content: DappContent.signTransaction(transaction),
        title: S.of(context).sign_transaction,
        buttonTitle: S.of(context).confirm,
        autoDismiss: false, sheetAction: () {
      clickAction();
    }, cancelAction: () {
      cancelAction();
    });
  }

  static actions(BuildContext context, List<String> options,
      List<String> images, Function(int) clickAction) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0))),
        backgroundColor: Colours.bg_color,
        builder: (BuildContext context) {
          return Container(
              height: options.length * 50 + 60.0,
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int posion) {
                    return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          clickAction(posion);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LoadAssetImage(images[posion],
                                    color: Colours.app_main, width: 20),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  options[posion],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )));
                  }));
        });
  }

  static showSheetWithContent(BuildContext context,
      {Widget content,
      String title,
      String buttonTitle,
      bool autoDismiss = true,
      Function() sheetAction,
      Function() cancelAction}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0))),
        builder: (BuildContext context) {
          return AnimatedPadding(
              //showModalBottomSheet 键盘弹出时自适应
              padding: MediaQuery.of(context).viewInsets, //边距（必要）
              duration: const Duration(milliseconds: 100), //时常 （必要）
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15, right: Screen.width - Screen.height * 5 / 6 + 15),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 60, //设置最小高度（必要）
                    maxHeight:
                        MediaQuery.of(context).size.height * 0.9, //设置最大高度（必要）
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                          Gaps.vGap12,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  minSize: 30,
                                  child: LoadAssetImage(
                                    "dapp/dapp_close",
                                    width: 24,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    cancelAction();
                                  })
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: content),
                          Container(
                              width: Screen.width - 40,
                              child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  minSize: 30,
                                  color: Colours.app_main,
                                  child: Text(
                                    buttonTitle,
                                    style: TextStyles.dapp_sheet_button,
                                  ),
                                  onPressed: () {
                                    autoDismiss
                                        ? Navigator.of(context).pop()
                                        : null;
                                    sheetAction();
                                  })),
                          Gaps.vGap18
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}

class DappContent {
  static Widget detail(DappConf dapp) {
    BuildContext context = navigatorKey.currentState.overlay.context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        detailCell(S.of(context).dapp_name,
            LocaleProvider().localeIndex > 0 ? dapp.nameCn : dapp.nameEn),
        Gaps.vGap10,
        detailCell(
            S.of(context).dapp_introduce,
            LocaleProvider().localeIndex > 0
                ? dapp.introductionCn
                : dapp.introductionEn),
        Gaps.vGap10,
        detailCell(S.of(context).dapp_link, dapp.url),
        Gaps.vGap20,
        ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                width: Screen.width - 40,
                color: Colours.bg_dark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).dapp_warning,
                      style: TextStyles.dapp_warn_title,
                    ),
                    Gaps.vGap10,
                    Text(
                      S.of(context).dapp_warning_tips,
                      style: TextStyles.dapp_warn_content,
                    ),
                  ],
                )))
      ],
    );
  }

  static Widget signMessage(String signString) {
    BuildContext context = navigatorKey.currentState.overlay.context;
    return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        child: Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            width: Screen.width - 40,
            color: Colours.bg_dark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).sign_content,
                  style: TextStyles.dapp_warn_content,
                ),
                Gaps.vGap10,
                Text(
                  signString,
                  style: TextStyles.dapp_warn_title,
                ),
              ],
            )));
  }

  static Widget signTransaction(DappTransaction transaction) {
    BuildContext context = navigatorKey.currentState.overlay.context;
    double gasPrice = BigInt.parse(transaction.gas).toInt() * 0.000000006;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                width: Screen.width - 40,
                color: Colours.bg_dark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TransferContent.addressItem(
                        S.of(context).contract_address, transaction.to),
                    TransferContent.addressItem(
                        S.of(context).transaction_content, transaction.data),
                  ],
                ))),
        Gaps.vGap10,
        ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                width: Screen.width - 40,
                color: Colours.bg_dark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_gas,
                            style: TextStyles.dapp_warn_title),
                        Gaps.vGap5,
                        Text("$gasPrice", style: TextStyles.dapp_warn_content),
                      ],
                    ),
                    Text("5.00 GWEI", style: TextStyles.dapp_warn_title)
                  ],
                )))
      ],
    );
  }

  static Widget detailCell(String desc, String content) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          width: 75,
          child: Text(
            desc,
            style: TextStyles.dapp_detail_title,
          )),
      Container(
          width: Screen.width - 115,
          child: Text(
            content,
            style: TextStyles.dapp_warn_title,
          ))
    ]);
  }
}
