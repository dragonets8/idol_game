import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/pages/token_receive_page.dart';
import 'package:idol_game/main/wallet/pages/token_transfer_page.dart';
import 'package:idol_game/main/wallet/widgets/token_cell.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum TokenSelectType { receive, transfer }

class TokenSelectPage extends StatefulWidget {
  TokenSelectPage({Key key, this.myTokens, this.selectType, this.targetAddress})
      : super();

  final List<TokenEntity> myTokens;
  final TokenSelectType selectType;
  final String targetAddress;

  @override
  TokenSelectState createState() => TokenSelectState();
}

class TokenSelectState extends State<TokenSelectPage> {
  openTokenReveive(TokenEntity tokenItem) {
    NavigatorUtils.pushTransparentPage(
        context,
        widget.selectType == TokenSelectType.receive
            ? TokenReceivePage(tokenItem: tokenItem)
            : TokenTransferPage(
                tokenItem: tokenItem,
                targetAddress: widget.targetAddress,
              ));
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
                      NaviBar(title: S.of(context).token_select),
                      Gaps.vGap15,
                      Expanded(
                          child: Container(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: widget.myTokens.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TokenSelectCell(
                                        tokenItem: widget.myTokens[index],
                                        tokenClick: (tokenName) {
                                          openTokenReveive(
                                              widget.myTokens[index]);
                                        });
                                  })))
                    ],
                  ),
                )))));
  }
}
