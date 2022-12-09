import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/database/chain_database.dart';
import 'package:idol_game/database/token_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/pages/nft_list_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class TokenAddPage extends StatefulWidget {
  TokenAddPage({Key key}) : super(key: key);

  @override
  TokenAddState createState() => TokenAddState();
}

class TokenAddState extends State<TokenAddPage> {
  int selectIndex = 0;
  List<Chain> allChain = [];
  List<TokenEntity> allToken = [];
  List<TokenEntity> tokenList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChainDB().queryAllChain((chainData) {
        Map<String, dynamic> chainMap = {"chains": chainData};
        ChainEntity chainEntity = ChainEntity.fromJson(chainMap);
        allChain = chainEntity.chains;
      });
      TokenDB().queryToken("id > 0", (queryData) {
        Map<String, dynamic> tokenMap = {"list": queryData};
        TokenEntityList tokenEntityList = TokenEntityList.fromJson(tokenMap);
        allToken = tokenEntityList.list;
        switchChain(0);
      });
    });
  }

  openExplore() {
    NavigatorUtils.pushTransparentPage(context, NFTListPage());
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: S.of(context).token_add),
                      Gaps.vGap20,
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              child: Container(
                                  width: Screen.width - 40,
                                  color: Colours.bg_dark,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        chainSegment(),
                                        Container(
                                          width: 0.8,
                                          color: Colours.line,
                                        ),
                                        Expanded(
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 8, bottom: 8),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: tokenList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return tokenAddCell(
                                                          tokenList[index]);
                                                    })))
                                      ]))))
                    ],
                  ),
                )))));
  }

  switchChain(int chainIndex) {
    List<TokenEntity> chainTokens = [];
    String chainSymbol = allChain[chainIndex].type;
    for (TokenEntity smartToken
        in allToken.where((token) => token.name != "BTC").toList()) {
      if (smartToken.chain == chainSymbol) {
        chainTokens.add(smartToken);
      }
    }
    if (!mounted) return;
    setState(() {
      selectIndex = chainIndex;
      tokenList = chainTokens;
    });
  }

  Widget chainSegment() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: chainSeg(),
        ));
  }

  List<Widget> chainSeg() {
    List<Widget> seg = [];
    for (var i = 0; i < allChain.length; i++) {
      seg.add(chainSegItem(i));
    }
    return seg;
  }

  Widget chainSegItem(int chainIndex) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          switchChain(chainIndex);
        },
        child: Container(
            width: 70,
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Column(
              children: [
                chainIndex == selectIndex
                    ? CachedNetworkImage(
                        width: 32,
                        imageUrl: "${allChain[chainIndex].image}",
                      )
                    : CachedNetworkImage(
                        width: 32,
                        imageUrl: "${allChain[chainIndex].image}",
                        color: Colours.bg_dark,
                        colorBlendMode: BlendMode.color,
                      ),
                Gaps.vGap8,
                Text(allChain[chainIndex].name,
                    style: chainIndex == selectIndex
                        ? TextStyles.token_add_seg2
                        : TextStyles.token_add_seg1),
              ],
            )));
  }

  getTokenAddress(String originalAddress) {
    String prefix = originalAddress.substring(0, 12);
    String suffix = originalAddress.substring(
        originalAddress.length - 13, originalAddress.length - 1);
    return prefix + "..." + suffix;
  }

  Widget tokenAddCell(TokenEntity tokenItem) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: tokenItem.image,
                    width: 30,
                  ),
                  Gaps.hGap12,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(tokenItem.name,
                              style: TextStyles.token_add_title),
                          Gaps.hGap5,
                          Text(tokenItem.chain,
                              style: TextStyles.token_add_desc)
                        ],
                      ),
                      Gaps.vGap5,
                      Text(getTokenAddress(tokenItem.address),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.token_add_address)
                    ],
                  )
                ],
              ),
              addItem(tokenItem)
            ],
          ),
        ),
        Container(
          height: 0.8,
          color: Colours.line,
        )
      ],
    );
  }

  Widget addItem(TokenEntity tokenItem) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            tokenItem.isSelect = tokenItem.isSelect == 1 ? 0 : 1;
          });
          TokenDB().updateToken(tokenItem.id, {"isSelect": tokenItem.isSelect});
          bus.emit("switch_wallet");
        },
        child: LoadAssetImage(
            tokenItem.isSelect == 1
                ? "wallet/addtoken_added"
                : "wallet/addtoken_add",
            color:
                tokenItem.isSelect == 1 ? Colours.app_main : Colours.text_light,
            width: 20));
  }
}
