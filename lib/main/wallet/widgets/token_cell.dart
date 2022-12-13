import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class TokenCell extends StatefulWidget {
  TokenCell({Key key, this.tokenItem, this.tokenClick}) : super(key: key);

  final TokenEntity tokenItem;
  final Function(TokenEntity) tokenClick;

  @override
  TokenCellState createState() => TokenCellState();
}

class TokenCellState extends State<TokenCell> {
  Widget chainImage = SizedBox();

  @override
  @override
  void initState() {
    super.initState();
    getChainImage();
  }

  getChainImage() async {
    if (widget.tokenItem.contract != "") {
      setState(() {
        chainImage = ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(7.0),
            ),
            child: CachedNetworkImage(
              width: 14,
              imageUrl: "http://45.112.206.236:9810/icon/token/bnb.png",
              color: Colours.bg_dark,
              colorBlendMode: BlendMode.color,
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.tokenClick(widget.tokenItem);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 3, 2),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.tokenItem.image,
                                        width: 30,
                                      )),
                                  chainImage,
                                ],
                              ),
                              Gaps.hGap10,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.tokenItem.name,
                                    style: TextStyles.token_name,
                                  ),
                                  Gaps.vGap5,
                                  Text(
                                    CurrencyProvider().currencyIndex == 1
                                        ? "￥${widget.tokenItem.cnyPrice}"
                                        : "\$ ${widget.tokenItem.usdPrice}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontFamily: "D-DIN",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${widget.tokenItem.balance}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colours.text,
                                fontFamily: "D-DIN",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gaps.vGap5,
                            Text(
                              CurrencyProvider().currencyIndex == 1
                                  ? "￥${widget.tokenItem.legalBalance}"
                                  : "\$ ${widget.tokenItem.legalBalance}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colours.dark_text_light,
                                fontFamily: "D-DIN",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))));
  }
}

class TokenSelectCell extends StatelessWidget {
  const TokenSelectCell({Key key, this.tokenItem, this.tokenClick})
      : super(key: key);

  final TokenEntity tokenItem;
  final Function(TokenEntity) tokenClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          tokenClick(tokenItem);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 6),
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: tokenItem.image,
                                width: 25,
                              ),
                              Gaps.hGap12,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tokenItem.name,
                                    style: TextStyles.token_name,
                                  ),
                                ],
                              ),
                            ]),
                        Text(
                          "${tokenItem.balance}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontFamily: "D-DIN",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )))));
  }
}
