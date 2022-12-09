import 'dart:math';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';

class WalletPanel extends StatelessWidget {
  WalletPanel({Key key, this.tokenList, this.optionClick}) : super(key: key);

  List<TokenEntity> tokenList = [];
  final Function(int) optionClick;

  double totalBtcBalance() {
    double totalBtc = 0.0;
    for (var i = 0; i < tokenList.length; i++) {
      TokenEntity tokenItem = tokenList[i];
      double legalBalance = tokenItem.balance * tokenItem.btcPrice;
      totalBtc = totalBtc + legalBalance;
    }
    return doubleDecimals(totalBtc, 6);
  }

  double totalLegalBalance() {
    double totalLegal = 0.0;
    for (var i = 0; i < tokenList.length; i++) {
      TokenEntity tokenItem = tokenList[i];
      double legalBalance = tokenItem.balance *
          (CurrencyProvider().currencyIndex == 1
              ? tokenItem.cnyPrice
              : tokenItem.usdPrice);
      totalLegal = totalLegal + legalBalance;
    }
    return doubleDecimals(totalLegal, 2);
  }

  double doubleDecimals(double value, int decimals) {
    int fac = pow(10, decimals);
    value = (value * fac).round() / fac;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
          color: Colours.bg_dark,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                      "${totalBtcBalance() ?? 0.0}",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontFamily: "D-DIN",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.hGap8,
                    Text(
                      "BTC",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        height: 2.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ]),
                  Gaps.vGap5,
                  Text(
                    CurrencyProvider().currencyIndex == 1
                        ? " ≈ ￥${totalLegalBalance() ?? 0.0}"
                        : " ≈ \$ ${totalLegalBalance() ?? 0.0}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontFamily: "D-DIN",
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildOptionButtons(
                      0, S.of(context).wallet_receive, "wallet/token_receive"),
                  buildOptionButtons(
                      1, S.of(context).wallet_send, "wallet/token_send")
                ],
              )
            ]),
          ],
        ));
  }

  Widget buildOptionButtons(int optionIndex, String title, String imagePath) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          optionClick(optionIndex);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 6),
            child: Row(children: [
              LoadAssetImage(
                imagePath,
                width: 16,
              ),
              Gaps.hGap8,
              Text(
                title,
                style: TextStyles.wallet_panel_button,
              ),
            ])));
  }
}
