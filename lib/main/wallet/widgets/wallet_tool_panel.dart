import 'package:idol_game/database/chain_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:idol_game/main/widgets/single_select_sheet.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/main.dart';

class WalletToolPanel extends StatefulWidget {
  WalletToolPanel({Key key, this.filterIndex, this.addClick, this.filterClick})
      : super(key: key);

  final Function(int) filterClick;
  final Function() addClick;
  final int filterIndex;

  @override
  WalletToolState createState() => WalletToolState();
}

class WalletToolState extends State<WalletToolPanel> {
  List<Chain> allChain = [];

  @override
  void initState() {
    super.initState();
    bus.on("refresh_chains", (args) {
      refreshChains();
    });
  }

  refreshChains() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChainDB().queryAllChain((chainData) {
        Map<String, dynamic> chainMap = {"chains": chainData};
        ChainEntity chainEntity = ChainEntity.fromJson(chainMap);
        setState(() {
          allChain = chainEntity.chains;
        });
      });
    });
  }

  openTokenFilter() {
    BuildContext context = navigatorKey.currentState.overlay.context;
    List<String> filterTitles = [S.of(context).wallet_assets_all];
    List<String> filterImages = ["wallet/chain_all"];
    for (var i = 0; i < allChain.length; i++) {
      Chain chain = allChain[i];
      filterTitles.add("${chain.name} ${S.of(context).wallet_assets}");
      filterImages.add(chain.image);
    }
    SingleSelectSheet.show(context, S.of(context).wallet_assets_filter,
        filterTitles, filterImages, widget.filterIndex, (sheetIndex) {
      widget.filterClick(sheetIndex);
    }, isChain: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          openTokenFilter();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(3, 5, 0, 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                widget.filterIndex == 0
                    ? S.of(context).wallet_assets_all
                    : allChain[widget.filterIndex - 1].name +
                        " " +
                        S.of(context).wallet_assets,
                style: TextStyles.wallet_asset_title,
              ),
              Gaps.hGap8,
              LoadAssetImage(
                "wallet/arrow_down",
                color: Colours.text_gray,
                width: 12,
              )
            ]),
            CupertinoButton(
                padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                minSize: 20,
                child: LoadAssetImage(
                  "wallet/token_add",
                  color: Colours.app_main,
                  width: 18,
                ),
                onPressed: () {
                  widget.addClick();
                }),
            // buildSearchBar()
          ]),
        ));
  }

  Widget buildSearchBar() {
    return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colours.line,
            width: 120,
            height: 30,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LoadAssetImage("wallet/search", width: 10),
                  Gaps.hGap5,
                  Expanded(
                      child: CupertinoTextField(
                    cursorHeight: 13,
                    placeholder:
                        S.of(navigatorKey.currentState.overlay.context).search,
                    decoration: null,
                    maxLines: 1,
                    cursorColor: Colours.app_main,
                    style: TextStyles.transmit_hash,
                    onChanged: (String textInput) {},
                  )),
                ])));
  }
}
