import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/models/token_transfer.dart';
import 'package:idol_game/main/widgets/buttons.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/qrcode_scanner.dart';
import 'package:idol_game/main/widgets/transfer_sheet.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:idol_game/utils/valid_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TokenTransferPage extends StatefulWidget {
  TokenTransferPage({Key key, this.tokenItem, this.targetAddress})
      : super(key: key);

  final TokenEntity tokenItem;
  final String targetAddress;

  @override
  TokenTransferState createState() => TokenTransferState();
}

class TokenTransferState extends State<TokenTransferPage> {
  double transferAmount = 0.0;
  TextEditingController amountController = TextEditingController(text: "");

  String receiveAddress = "";
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      receiveAddress = widget.targetAddress ?? "";
      textController.text = widget.targetAddress ?? "";
    });
  }

  transferToken() {
    FocusScope.of(context).unfocus();
    TransferSheet.show(
        context, widget.tokenItem, transferAmount, receiveAddress, () {
      SecurityUtils.showAuth(context, unlockHandler: (privateKey) {
        transfer(privateKey);
      });
    });
  }

  String getChainName(TokenEntity tokenItem) {
    if (tokenItem.name == "BTC") {
      return "OMNI";
    } else {
      return tokenItem.chain;
    }
  }

  bool inputCorrect() {
    return ValidUtils.isEthAddress(receiveAddress) &&
        transferAmount > 0 &&
        transferAmount <= widget.tokenItem.balance;
  }

  transferAll() {
    setState(() {
      transferAmount = widget.tokenItem.balance;
      amountController =
          TextEditingController(text: widget.tokenItem.balance.toString());
    });
  }

  scanQrcode() async {
    FocusScope.of(context).unfocus();
    Future.delayed(Duration(milliseconds: 200), () {
      NavigatorUtils.pushTransparentPage(context,
          QRCodeScanner(scanComplete: (qrcode) {
        String qrAddress = qrcode.replaceFirst("ethereum:", "");
        setState(() {
          receiveAddress = qrAddress;
          textController.text = qrAddress;
        });
      }));
    });
  }

  transfer(String key) async {
    EasyLoading.show();
    String chain = widget.tokenItem.chain;
    print("转账：${widget.tokenItem.name}，链类型：${widget.tokenItem.chain}");
    if (chain == "ERC20") {
      if (widget.tokenItem.name == "ETH") {
        transferEth(transferAmount, private: key, toAddress: receiveAddress)
            .then((tx) {
          transactionSuccess(tx);
        });
      } else {
        transferErc20(transferAmount,
                private: key,
                toAddress: receiveAddress,
                contract: ContractConfig.usdt.erc20)
            .then((tx) {
          transactionSuccess(tx);
        });
      }
    }
    if (chain == "BEP20") {
      if (widget.tokenItem.name == "BNB") {
        transferBnb(transferAmount, private: key, toAddress: receiveAddress)
            .then((tx) {
          transactionSuccess(tx);
        });
      } else {
        transferBep20(transferAmount,
                private: key,
                toAddress: receiveAddress,
                contract: ContractConfig.xwg.bep20)
            .then((tx) {
          transactionSuccess(tx);
        });
      }
    }
    if (chain == "HRC20") {
      if (widget.tokenItem.name == "HT") {
        // 转账HT
        transferHt(transferAmount, private: key, toAddress: receiveAddress)
            .then((tx) {
          transactionSuccess(tx);
        });
      } else {
        // 转账HECO
        transferHrc20(transferAmount,
                private: key,
                toAddress: receiveAddress,
                contract: ContractConfig.link.hrc20)
            .then((tx) {
          transactionSuccess(tx);
        });
      }
    }
  }

  transactionSuccess(String tx) {
    print(tx);
    EasyLoading.dismiss();
    Navigator.of(context).pop();
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
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                                child: Text(S.of(context).receive_address,
                                    style: TextStyles.token_transfer_title)),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: CupertinoTextField(
                                        controller: textController,
                                        cursorHeight: 18,
                                        placeholder: S
                                            .of(context)
                                            .receive_address_placeholder,
                                        decoration: null,
                                        cursorColor: Colours.app_main,
                                        style:
                                            TextStyles.token_transfer_address,
                                        placeholderStyle:
                                            TextStyles.token_transfer_place1,
                                        onChanged: (String textInput) {
                                          setState(() {
                                            receiveAddress = textInput;
                                          });
                                        },
                                      )),
                                      CupertinoButton(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          minSize: 20,
                                          child: LoadAssetImage(
                                            "dapp/dapp_scan",
                                            width: 18,
                                          ),
                                          onPressed: () {
                                            scanQrcode();
                                          }),
                                    ],
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).transfer_amount,
                                        style: TextStyles.token_transfer_title),
                                    Text(
                                        S.of(context).transfer_available +
                                            ": ${widget.tokenItem.balance}",
                                        style:
                                            TextStyles.token_transfer_available)
                                  ],
                                )),
                            ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: CupertinoTextField(
                                              controller: amountController,
                                              cursorHeight: 18,
                                              placeholder: S
                                                  .of(context)
                                                  .transfer_amount_placeholder,
                                              decoration: null,
                                              cursorColor: Colours.app_main,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r"^[0-9]+\.?[0-9]*$"))
                                              ],
                                              style: TextStyles
                                                  .token_transfer_amount,
                                              placeholderStyle: TextStyles
                                                  .token_transfer_place2,
                                              onChanged: (String textInput) {
                                                setState(() {
                                                  transferAmount = textInput ==
                                                          ""
                                                      ? 0.0
                                                      : double.parse(textInput);
                                                });
                                              },
                                            )),
                                            CupertinoButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                child: Text(
                                                  S.of(context).transfer_all,
                                                  style: TextStyles
                                                      .token_transfer_all,
                                                ),
                                                onPressed: () {
                                                  transferAll();
                                                })
                                          ],
                                        ),
                                        Text(
                                            CurrencyProvider().currencyIndex ==
                                                    1
                                                ? "  ≈ ￥ ${transferAmount * widget.tokenItem.cnyPrice}"
                                                : "  ≈ \$ ${transferAmount * widget.tokenItem.usdPrice}",
                                            style: TextStyles
                                                .token_transfer_address)
                                      ],
                                    ))),
                            Gaps.vGap20,
                            Buttons.stateButton(
                                title: S.of(context).confirm,
                                enable: inputCorrect(),
                                click: () {
                                  transferToken();
                                }),
                          ])))
                    ],
                  ),
                )))));
  }
}
