import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/models/transaction_entity.dart';
import 'package:idol_game/main/wallet/pages/token_receive_page.dart';
import 'package:idol_game/main/wallet/pages/token_transfer_page.dart';
import 'package:idol_game/main/wallet/pages/transfer_detail_page.dart';
import 'package:idol_game/main/wallet/widgets/token_detail_panel.dart';
import 'package:idol_game/main/wallet/widgets/token_option_panel.dart';
import 'package:idol_game/main/wallet/widgets/transaction_cell.dart';
import 'package:idol_game/main/widgets/common_webview.dart';
import 'package:idol_game/main/widgets/custom_widgets.dart';
import 'package:idol_game/main/widgets/empty_widgets.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:frefresh/frefresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class TokenDetailPage extends StatefulWidget {
  TokenDetailPage({Key key, this.tokenItem}) : super(key: key);

  final TokenEntity tokenItem;

  @override
  TokenDetailPageState createState() => TokenDetailPageState();
}

class TokenDetailPageState extends State<TokenDetailPage> {
  int nextPage = 2;
  List<Transaction> transactionList = [];
  FRefreshController controller = FRefreshController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tokenItem.name != "BTC") {
        getTransactions(true);
      }
    });
  }

  openTransactionDetail(Transaction transaction) {
    NavigatorUtils.pushTransparentPage(
        context,
        TransferDetailPage(
            tokenItem: widget.tokenItem, transaction: transaction));
  }

  String getChainName(TokenEntity tokenItem) {
    if (tokenItem.name == "BTC") {
      return "OMNI";
    } else {
      return tokenItem.chain;
    }
  }

  getTransactions(bool isRefresh) {
    Map<String, dynamic> parama = {
      "apikey": "",
      "module": "account",
      "address": widget.tokenItem.address,
      "page": isRefresh ? 1 : nextPage,
      "offset": "20",
      "sort": "desc",
      "chain": widget.tokenItem.chain.toLowerCase(),
      "action": "",
      "contractaddress": "",
      "envProd": isMainnet
    };
    if (widget.tokenItem.contract == "") {
      parama["action"] = "txlist";
    } else {
      parama["action"] = "tokentx";
      parama["contractaddress"] = widget.tokenItem.contract;
    }
    DioManager().request<TransactionEntity>(Apis.queryTranscation,
        params: parama, success: (transactionEntity) {
      getTokenTransactions(isRefresh, transactionEntity);
    }, error: (error) {
      print(error.message);
    });
  }

  getTokenTransactions(bool isRefresh, TransactionEntity transaction) {
    List<Transaction> transactions = transaction.result ?? [];
    if (!mounted) return;
    setState(() {
      if (isRefresh) {
        transactionList = transactions;
      } else {
        transactionList.addAll(transactions);
      }
    });
    if (isRefresh) {
      nextPage = 2;
    } else {
      nextPage++;
    }
    controller.finishLoad();
    controller.finishRefresh();
  }

  openOption(int optionIndex) async {
    String exploreUrl =
        ChainConfig.bep20.explorer + "/address/${widget.tokenItem.address}";
    List optionPages = [
      TokenTransferPage(tokenItem: widget.tokenItem),
      TokenReceivePage(tokenItem: widget.tokenItem),
      CommonWebView(title: ChainConfig.bep20.explorer, initialUrl: exploreUrl)
    ];
    NavigatorUtils.pushTransparentPage(context, optionPages[optionIndex]);
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
                            NaviBar(
                                title:
                                    "${widget.tokenItem.name} (${getChainName(widget.tokenItem)})"),
                            Gaps.vGap10,
                            Expanded(
                                child: FRefresh(
                              controller: controller,
                              header: CustomWidgets.refreshHeader(40),
                              footer: Text("加载中...",
                                  textAlign: TextAlign.center,
                                  style: TextStyles.my_title),
                              headerHeight: 40.0,
                              footerHeight: 50.0,
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: transactionList.length + 2,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return transctionListItem(index);
                                  }),
                              onRefresh: () {
                                getTransactions(true);
                              },
                              onLoad: () {
                                getTransactions(false);
                              },
                            )),
                          ],
                        ))))));
  }

  Widget transctionListItem(int itemIndex) {
    if (itemIndex == 0) {
      return buildTokenHeader();
    } else if (itemIndex == 1) {
      return transactionList.length > 0
          ? SizedBox()
          : EmptyWidgets.listEmpty(S.of(context).transaction_no_data);
    } else {
      return transactionList.length == 0
          ? SizedBox()
          : TransactionCell(
              tokenItem: widget.tokenItem,
              transaction: transactionList[itemIndex - 2],
              transactionClick: (transaction) {
                openTransactionDetail(transaction);
              });
    }
  }

  Widget buildTokenHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Gaps.vGap10,
      TokenDetailPanel(tokenItem: widget.tokenItem),
      Gaps.vGap15,
      TokenOptionPanel(optionClick: (optionIndex) {
        openOption(optionIndex);
      }),
      Container(
          padding: EdgeInsets.fromLTRB(5, 8, 0, 6),
          child: Text(
            S.of(context).wallet_transaction,
            style: TextStyles.dapp_search_title,
          ))
    ]);
  }
}
