import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class TokenOptionPanel extends StatelessWidget {
  const TokenOptionPanel({Key key, this.optionClick}) : super(key: key);

  final Function(int) optionClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Expanded(
          child: buildOptionButtons(
              0, S.of(context).wallet_send, "wallet/token_send"),
        ),
        Expanded(
          child: buildOptionButtons(
              1, S.of(context).wallet_receive, "wallet/token_receive"),
        ),
        Expanded(
          child: buildOptionButtons(
              2, S.of(context).wallet_browse, "wallet/token_search"),
        ),
      ]),
    );
  }

  Widget buildOptionButtons(int optionIndex, String title, String imagePath) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          optionClick(optionIndex);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    color: Colours.bg_dark,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadAssetImage(
                            imagePath,
                            width: 16,
                          ),
                          Gaps.hGap8,
                          Text(
                            title,
                            style: TextStyles.token_detail_button,
                          ),
                        ])))));
  }
}
