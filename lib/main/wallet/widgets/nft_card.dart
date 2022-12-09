import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/main/wallet/models/dreamcard_entity.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class NftCard extends StatelessWidget {
  NftCard({Key key, this.nftItem, this.nftClick}) : super(key: key);

  final NFTItem nftItem;
  final Function(NFTItem) nftClick;

  @override
  Widget build(BuildContext context) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        Expanded(
            flex: 13,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  nftClick(nftItem);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: (Screen.width - 60) / 3,
                      color: Colours.bg_dark,
                      child: CachedNetworkImage(
                        imageUrl: nftItem.image,
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
              "# ${nftItem.number}",
              style: TextStyles.token_nft_content,
            )),
        Gaps.vGap3,
        Expanded(
            flex: 2,
            child: Text(nftItem.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyles.token_nft_name))
      ],
    );
  }
}
