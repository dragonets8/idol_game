import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TokenDetailPanel extends StatelessWidget {
  const TokenDetailPanel({Key key, this.tokenItem}) : super(key: key);

  final TokenEntity tokenItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: tokenItem.image,
          width: 35,
        ),
        Gaps.hGap15,
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                "${tokenItem.balance}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: "D-DIN",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.hGap15,
              Text(
                CurrencyProvider().currencyIndex == 1
                    ? "￥${tokenItem.legalBalance}"
                    : "\$ ${tokenItem.legalBalance}",
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.white70,
                  fontFamily: "D-DIN",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
            Gaps.vGap5,
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: tokenItem.address));
                  EasyLoading.showToast(S.of(context).copy_success);
                },
                child: Text(
                  tokenItem.address,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white54,
                    fontFamily: "D-DIN",
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ],
        ))
      ],
    );
  }
}
