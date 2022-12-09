import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class WalletToolBar extends StatelessWidget {
  const WalletToolBar(
      {Key key,
      this.walletTitle,
      this.switchClick,
      this.nftClick,
      this.myClick,
      this.messageClick})
      : super(key: key);

  final walletTitle;
  final Function() switchClick;
  final Function() nftClick;
  final Function() myClick;
  final Function() messageClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    switchClick();
                  },
                  child: Container(
                      height: 30,
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      color: Colours.text_gray,
                      child: Row(
                        children: [
                          Text(walletTitle.replaceAll("&&", ""),
                              style: TextStyles.token_name),
                          Gaps.hGap5,
                          LoadAssetImage(
                            "wallet/arrow_down",
                            width: 12,
                          )
                        ],
                      )))),
          Row(
            children: [
              CupertinoButton(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  minSize: 10,
                  child: LoadAssetImage('wallet/nft', width: 20),
                  onPressed: () => {nftClick()}),
              Gaps.hGap5,
              CupertinoButton(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  minSize: 10,
                  child: LoadAssetImage('wallet/item_my', width: 22),
                  onPressed: () => {myClick()}),
            ],
          )
        ],
      ),
    );
  }
}
