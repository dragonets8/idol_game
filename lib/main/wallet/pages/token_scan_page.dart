import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TokenScanPage extends StatefulWidget {
  TokenScanPage() : super();
  @override
  TokenScanState createState() => TokenScanState();
}

class TokenScanState extends State<TokenScanPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HalfWidthContainer(
            content: CupertinoPageScaffold(
                backgroundColor: Colours.bg_color,
                child: SafeArea(
                    child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: S.of(context).wallet_scan),
                      Gaps.vGap20,
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              width: Screen.width - 40,
                              color: Colors.white,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "BTC",
                                      style: TextStyles.transmit_amount,
                                    )
                                  ])))
                    ],
                  ),
                )))));
  }
}
