import 'dart:math';
import 'package:idol_game/database/chain_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/models/transaction_entity.dart';
import 'package:idol_game/main/widgets/common_webview.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/token_utils/string_util.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TransferDetailPage extends StatefulWidget {
  TransferDetailPage({Key key, this.tokenItem, this.transaction})
      : super(key: key);

  final TokenEntity tokenItem;
  final Transaction transaction;

  @override
  TransferDetailState createState() => TransferDetailState();
}

class TransferDetailState extends State<TransferDetailPage> {
  String gas = "";

  @override
  void initState() {
    super.initState();
    getGas();
  }

  openExplore() async {
    Chain chain = await ChainDB().queryChain(widget.tokenItem.chain);
    String exploreUrl =
        chain.blockBrowserUrl + "/tx/${widget.transaction.hash}";
    NavigatorUtils.pushTransparentPage(context,
        CommonWebView(title: chain.blockBrowserUrl, initialUrl: exploreUrl));
  }

  String transactionTitle() {
    if (widget.tokenItem.address == widget.transaction.to) {
      return widget.tokenItem.name + " " + S.of(context).wallet_receive;
    } else {
      return widget.tokenItem.name + " " + S.of(context).wallet_send;
    }
  }

  double doubleDecimals(double value) {
    int decimals = 6;
    int fac = pow(10, decimals);
    value = (value * fac).round() / fac;
    return value;
  }

  String transactionAmount() {
    double amount = bigNum2Double(BigInt.parse(widget.transaction.value),
        int.parse(widget.tokenItem.decimals));
    if (widget.tokenItem.address == widget.transaction.to) {
      return "+ " +
          doubleDecimals(amount).toString() +
          " ${widget.tokenItem.name}";
    } else {
      return "- " +
          doubleDecimals(amount).toString() +
          " ${widget.tokenItem.name}";
    }
  }

  String transactionStatus() {
    if (widget.tokenItem.address == widget.transaction.to) {
      return S.of(context).transaction_state_success;
    } else {
      return S.of(context).transaction_state_success;
    }
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
                      NaviBar(title: transactionTitle()),
                      Gaps.vGap20,
                      Expanded(
                          child: SingleChildScrollView(
                              child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            child: Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                width: Screen.width - 40,
                                color: Colours.bg_dark,
                                child: Column(children: [
                                  LoadAssetImage("wallet/transfer_success",
                                      width: 90),
                                  Text(
                                    transactionAmount(),
                                    style: TextStyles.transaction_amount,
                                  ),
                                  Gaps.vGap10,
                                  Text(
                                    transactionStatus(),
                                    style: TextStyles.transaction_status,
                                  ),
                                  Gaps.vGap20,
                                  transactionItem(
                                      S.of(context).transaction_from,
                                      widget.transaction.from,
                                      canCopy: true),
                                  transactionItem(S.of(context).transaction_to,
                                      widget.transaction.to,
                                      canCopy: true),
                                  transactionItem(S.of(context).transaction_gas,
                                      widget.transaction.gas,
                                      isGas: true),
                                  transactionItem(
                                      S.of(context).transaction_time,
                                      DateUtil.formatDateMs(
                                          widget.transaction.timeStamp * 1000,
                                          format: "yyyy-MM-dd HH:mm")),
                                  transactionItem(
                                      S.of(context).transaction_block_height,
                                      widget.transaction.blockNumber,
                                      canCopy: true),
                                  transactionItem(
                                      S.of(context).transaction_hash,
                                      widget.transaction.hash,
                                      canCopy: true),
                                  Gaps.vGap10,
                                  Container(
                                    height: 0.8,
                                    color: Colours.line,
                                  ),
                                  Gaps.vGap5,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      QrImage(
                                        data: widget.transaction.hash,
                                        size: 70,
                                        foregroundColor: Colours.text_gray,
                                      ),
                                      GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            openExplore();
                                          },
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 25, 0, 25),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      S
                                                          .of(context)
                                                          .transaction_broswer,
                                                      style: TextStyles
                                                          .transaction_title),
                                                  Gaps.hGap4,
                                                  LoadAssetImage(
                                                      "my/more_arrow",
                                                      width: 20),
                                                ],
                                              ))),
                                    ],
                                  )
                                ]))),
                      ))),
                    ],
                  ),
                )))));
  }

  Widget transactionItem(String title, String content,
      {bool canCopy = false, bool isGas = false}) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (canCopy) {
            Clipboard.setData(ClipboardData(text: content));
            EasyLoading.showToast(S.of(context).copy_success);
          }
        },
        child: Container(
          alignment: AlignmentDirectional.topStart,
          padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: TextStyles.transaction_title),
                  Gaps.hGap5,
                  canCopy
                      ? LoadAssetImage("wallet/address_copy", width: 15)
                      : SizedBox(),
                ],
              ),
              Gaps.vGap5,
              Text(isGas ? "$gas" : content,
                  style: TextStyles.transaction_content),
              Gaps.vGap3,
              isGas
                  ? Text(getGasDesc(), style: TextStyles.transaction_gas)
                  : SizedBox()
            ],
          ),
        ));
  }

  getGas() async {
    Chain chain = await ChainDB().queryChain(widget.tokenItem.chain);
    double gasPrice = int.parse(widget.transaction.gasPrice) / pow(10, 18);
    double gasValue = gasPrice * int.parse(widget.transaction.gasUsed);
    setState(() {
      gas = "$gasValue ${chain.symbol}";
    });
  }

  String getGasDesc() {
    double gasPrice = int.parse(widget.transaction.gasPrice) / 1000000000;
    return "Gas Price($gasPrice Gwei) x Gas(${widget.transaction.gasUsed})";
  }
}
