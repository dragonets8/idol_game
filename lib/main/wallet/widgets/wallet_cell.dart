import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class SwitchWalletCell extends StatelessWidget {
  const SwitchWalletCell({Key key, this.wallet, this.walletClick})
      : super(key: key);

  final Map<String, dynamic> wallet;
  final Function() walletClick;

  String getBriefAddress(String originalAddress) {
    return originalAddress.substring(0, 15) +
        "..." +
        originalAddress.substring(29, 42);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          walletClick();
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 3, 0, 6),
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                    color: Colours.bg_dark,
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallet["name"].replaceAll("&&", ""),
                              style: TextStyles.token_nft_button,
                            ),
                            Gaps.vGap5,
                            Text(
                              getBriefAddress(wallet["smart"]),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                                fontFamily: "D-DIN",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                        wallet["active"] == 1
                            ? LoadAssetImage(
                                "wallet/addtoken_added",
                                width: 14,
                              )
                            : SizedBox(),
                      ],
                    )))));
  }
}

class ManageWalletCell extends StatelessWidget {
  const ManageWalletCell({Key key, this.wallet, this.walletClick})
      : super(key: key);

  final Map<String, dynamic> wallet;
  final Function() walletClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          walletClick();
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                color: Colours.bg_dark,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallet["name"].replaceAll("&&", ""),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: "D-DIN",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gaps.vGap5,
                        Text(
                          wallet["smart"],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white60,
                            fontFamily: "D-DIN",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
                    LoadAssetImage("my/more_arrow", width: 18)
                  ],
                ),
              ),
            )));
  }
}
