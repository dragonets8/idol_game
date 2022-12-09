import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TransferSheet {
  static show(BuildContext context, TokenEntity tokenItem, double amount,
      String toAddress, Function() sheetAction) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
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
                        MediaQuery.of(context).size.height * 0.8, //设置最大高度（必要）
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
                          Gaps.vGap5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S.of(context).nft_transfer +
                                        " $amount ${tokenItem.name}",
                                    style: TextStyles.transfer_sheet_title,
                                  ),
                                  Gaps.hGap5,
                                  Text(
                                    "(${tokenItem.chain})",
                                    style: TextStyles.transfer_sheet_assist,
                                  ),
                                ],
                              ),
                              CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: LoadAssetImage(
                                    "dapp/dapp_close",
                                    width: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                              child:
                                  TransferContent.detail(context, toAddress)),
                          Container(
                              width: Screen.width - 80,
                              child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  minSize: 30,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colours.app_main,
                                  child: Text(
                                    S.of(context).confirm,
                                    style: TextStyles.dapp_sheet_button,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    sheetAction();
                                  })),
                          Gaps.vGap15
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}

class TransferContent {
  static Widget detail(BuildContext context, String reveiveAddress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                color: Colours.bg_dark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addressItem(S.of(context).receive_address, reveiveAddress),
                  ],
                ))),
        Gaps.vGap10,
        ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                color: Colours.bg_dark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_gas,
                            style: TextStyles.dapp_warn_title),
                        // Gaps.vGap5,
                        // Text("0.000025 BNB",
                        //     style: TextStyles.dapp_warn_content),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("5.00 GWEI", style: TextStyles.dapp_warn_title),
                        // Gaps.hGap8,
                        // LoadAssetImage(
                        //   "my/more_arrow",
                        //   width: 20,
                        // ),
                      ],
                    )
                  ],
                )))
      ],
    );
  }

  static Widget addressItem(String title, String address) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: TextStyles.dapp_warn_title),
            CupertinoButton(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                minSize: 20,
                child: LoadAssetImage(
                  "wallet/address_copy",
                  width: 16,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address));
                  EasyLoading.showToast("Copy successfully");
                })
          ],
        ),
        Gaps.vGap3,
        Text(address,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyles.dapp_warn_content),
      ],
    ));
  }
}
