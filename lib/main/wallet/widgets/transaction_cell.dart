import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/main/wallet/models/transaction_entity.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/wallet_hd/token_utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';

class TransactionCell extends StatelessWidget {
  const TransactionCell(
      {Key key, this.tokenItem, this.transaction, this.transactionClick})
      : super(key: key);

  final TokenEntity tokenItem;
  final Transaction transaction;
  final Function(Transaction) transactionClick;

  bool isReceive() {
    return tokenItem.address == transaction.to;
  }

  String getDescription() {
    BuildContext context = navigatorKey.currentState.overlay.context;
    if (isReceive()) {
      return "${S.of(context).wallet_receive}: " +
          transaction.from.substring(0, 8) +
          "..." +
          transaction.from.substring(36, 42);
    } else {
      return "${S.of(context).wallet_send}: " +
          transaction.to.substring(0, 8) +
          "..." +
          transaction.to.substring(36, 42);
    }
  }

  String getChainName(TokenEntity tokenItem) {
    if (tokenItem.name == "BTC") {
      return "OMNI";
    } else {
      return tokenItem.chain;
    }
  }

  double getLegalBlance() {
    double legalBlance =
        bigNum2Double(transaction.value, int.parse(tokenItem.decimals)) *
            (CurrencyProvider().currencyIndex == 1
                ? tokenItem.cnyPrice
                : tokenItem.usdPrice);
    int fac = pow(10, 2);
    legalBlance = (legalBlance * fac).round() / fac;
    return legalBlance;
  }

  double getGas() {
    double gasPrice = int.parse(transaction.gasPrice) / pow(10, 18);
    return gasPrice * int.parse(transaction.gasUsed);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          transactionClick(transaction);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
                  color: Colors.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LoadAssetImage(
                            isReceive()
                                ? "wallet/transaction_receive"
                                : "wallet/transaction_send",
                            height: 20),
                        Gaps.hGap10,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getDescription(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colours.text,
                                    fontFamily: "D-DIN",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  (isReceive() ? "+ " : "- ") +
                                      "${bigNum2Double(transaction.value, int.parse(tokenItem.decimals))}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colours.bg_dark,
                                    fontFamily: "D-DIN",
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Gaps.vGap3,
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateUtil.formatDateMs(
                                        transaction.timeStamp * 1000,
                                        format: 'yyyy-MM-dd HH:mm:ss'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colours.dark_text_gray,
                                      fontFamily: "D-DIN",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    CurrencyProvider().currencyIndex == 1
                                        ? "≈ ￥${getLegalBlance()}"
                                        : "≈ \$ ${getLegalBlance()}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                      fontFamily: "D-DIN",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ]),
                          ],
                        )),
                      ]),
                ))));
  }
}
