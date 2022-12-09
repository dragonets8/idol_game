import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/nft_tool.dart';
import 'package:idol_game/main/wallet/models/dreamcard_transaction.dart';
import 'package:idol_game/main/widgets/common_webview.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class NFTHistoryPage extends StatefulWidget {
  NFTHistoryPage({Key key, this.cardAddress, this.contractAddress})
      : super(key: key);

  final String cardAddress;
  final String contractAddress;

  @override
  NFTHistoryState createState() => NFTHistoryState();
}

class NFTHistoryState extends State<NFTHistoryPage> {
  List<DreamCardTransaction> transactionList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTokenTransactions();
    });
  }

  openExplore(DreamCardTransaction transaction) {
    SmartChain smartChain = ChainConfig.bep20;
    String exploreUrl = smartChain.explorer + "/tx/${transaction.hash}";
    NavigatorUtils.pushTransparentPage(
        context, CommonWebView(title: smartChain.scan, initialUrl: exploreUrl));
  }

  getTokenTransactions() {
    NFTTool.nftTransactions(widget.cardAddress, widget.contractAddress,
        (transactions) {
      if (!mounted) return;
      setState(() {
        DreamCardTransactions dreamCardTransactions = transactions;
        List<DreamCardTransaction> result = dreamCardTransactions.result ?? [];
        transactionList = result;
      });
    });
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: "Transaction"),
                      Gaps.vGap15,
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: transactionList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return DreamCardHistoryCell(
                                    cardAddress: widget.cardAddress,
                                    transaction: transactionList[index],
                                    transactionClick: (transaction) {
                                      openExplore(transaction);
                                    });
                              }))
                    ],
                  ),
                )))));
  }
}

class DreamCardHistoryCell extends StatelessWidget {
  const DreamCardHistoryCell(
      {Key key, this.cardAddress, this.transaction, this.transactionClick})
      : super(key: key);

  final String cardAddress;
  final DreamCardTransaction transaction;
  final Function(DreamCardTransaction) transactionClick;

  @override
  Widget build(BuildContext context) {
    bool isReceive = cardAddress.toLowerCase() == transaction.to;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          transactionClick(transaction);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                  color: Colours.bg_dark,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isReceive
                                      ? S.of(context).nft_receive + " "
                                      : S.of(context).nft_transfer + " ",
                                  style: TextStyles.nft_history_send,
                                ),
                                Text(
                                  " # ${transaction.tokenId}",
                                  style: TextStyles.nft_history_title,
                                ),
                              ],
                            ),
                            Text(
                              DateUtil.formatDateMs(
                                  int.parse(transaction.timeStamp) * 1000,
                                  format: 'yyyy-MM-dd HH:mm'),
                              style: TextStyles.nft_history_time,
                            ),
                          ],
                        ),
                        Gaps.vGap8,
                        Text(transaction.hash,
                            style: TextStyles.nft_history_hash),
                      ]),
                ))));
  }
}
