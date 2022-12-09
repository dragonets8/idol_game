import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/main/wallet/models/dreamcard_entity.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class LucidCard extends StatelessWidget {
  LucidCard({Key key, this.lucidItem, this.lucidClick}) : super(key: key);

  final LucidItem lucidItem;
  final Function(LucidItem) lucidClick;

  @override
  Widget build(BuildContext context) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        Expanded(
            flex: 14,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  lucidClick(lucidItem);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: (Screen.width - 50) / 3,
                      color: Colours.bg_dark,
                      child: CachedNetworkImage(
                        imageUrl: lucidItem.image,
                        placeholder: (context, url) => Icon(
                          Icons.image,
                          size: Screen.height / 8,
                          color: Colours.text_gray,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: Colours.text_gray),
                      ),
                    )))),
        Gaps.vGap5,
        Expanded(
          flex: 2,
          child: Text(
            "# ${lucidItem.number}",
            style: TextStyles.token_nft_content,
          ),
        ),
        Gaps.vGap5,
        Expanded(
            flex: 2,
            child: Text(
              "${lucidItem.name}",
              style: TextStyles.nft_history_time,
            )),
        Gaps.vGap5,
        Expanded(
            flex: 2,
            child: Text(lucidItem.amount,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyles.token_nft_name))
      ],
    );
  }
}
