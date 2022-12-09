import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/pages/wallet_home_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class TokenReceivePage extends StatefulWidget {
  TokenReceivePage({Key key, this.tokenItem}) : super(key: key);

  final TokenEntity tokenItem;

  @override
  TokenReceivePageState createState() => TokenReceivePageState();
}

class TokenReceivePageState extends State<TokenReceivePage> {
  openHome() {
    Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(
        builder: (_) {
          return WalletHomePage();
        },
        fullscreenDialog: true));
  }

  String getChainName(TokenEntity tokenItem) {
    if (tokenItem.name == "BTC") {
      return "OMNI";
    } else {
      return tokenItem.chain;
    }
  }

  copyAddress() {
    Clipboard.setData(ClipboardData(text: widget.tokenItem.address));
    EasyLoading.showToast("Copy successfully");
  }

  shareAddress() {
    Share.share(widget.tokenItem.address);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HalfWidthContainer(
            content: CupertinoPageScaffold(
                backgroundColor: Colours.bg_color,
                child: SafeArea(
                    child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: S.of(context).wallet_receive),
                      Gaps.vGap10,
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(25, 20, 25, 15),
                              width: Screen.height / 1.2,
                              color: Colors.white,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: widget.tokenItem.image,
                                          width: 30,
                                        ),
                                        Gaps.hGap10,
                                        Text(
                                          "${widget.tokenItem.name} (${getChainName(widget.tokenItem)})",
                                          style: TextStyles.token_receive_title,
                                        ),
                                      ],
                                    ),
                                    Gaps.vGap10,
                                    QrImage(
                                      data: widget.tokenItem.address,
                                      size: Screen.height / 3,
                                      foregroundColor: Colours.text,
                                    ),
                                    Gaps.vGap12,
                                    Text(
                                      widget.tokenItem.address,
                                      textAlign: TextAlign.center,
                                      style: TextStyles.token_receive_address,
                                    ),
                                    Gaps.vGap10,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: CupertinoButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 8, 30, 8),
                                                color: Colours.bg_dark,
                                                minSize: 10,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                child: Text(S.of(context).copy,
                                                    style: TextStyles
                                                        .token_receive_button),
                                                onPressed: () =>
                                                    {copyAddress()})),
                                        SizedBox(width: 30),
                                        Expanded(
                                            child: CupertinoButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 8, 10, 8),
                                                color: Colours.bg_dark,
                                                minSize: 10,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                child: Text(S.of(context).share,
                                                    style: TextStyles
                                                        .token_receive_button),
                                                onPressed: () =>
                                                    {shareAddress()}))
                                      ],
                                    )
                                  ])))
                    ],
                  ),
                )))));
  }
}
