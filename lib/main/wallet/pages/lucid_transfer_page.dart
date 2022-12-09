import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:idol_game/abi/lucid.g.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/dreamcard_entity.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/widgets/buttons.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/qrcode_scanner.dart';
import 'package:idol_game/main/widgets/transfer_sheet.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:idol_game/utils/valid_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';

class LucidTransferPage extends StatefulWidget {
  LucidTransferPage({Key key, this.lucidItem, this.lucidToken})
      : super(key: key);

  final LucidItem lucidItem;
  final TokenEntity lucidToken;

  @override
  TokenTransferState createState() => TokenTransferState();
}

class TokenTransferState extends State<LucidTransferPage> {
  int transferAmount = 0;
  TextEditingController amountController = TextEditingController(text: "");

  String receiveAddress = "";
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  transferToken() {
    FocusScope.of(context).unfocus();
    TransferSheet.show(
        context, widget.lucidToken, transferAmount.toDouble(), receiveAddress,
        () {
      SecurityUtils.showAuth(context, unlockHandler: (privateKey) {
        transfer(privateKey);
      });
    });
  }

  bool inputCorrect() {
    return ValidUtils.isEthAddress(receiveAddress) &&
        transferAmount > 0 &&
        transferAmount <= widget.lucidToken.balance;
  }

  transferAll() {
    setState(() {
      transferAmount = widget.lucidToken.balance.toInt();
      amountController =
          TextEditingController(text: "${widget.lucidToken.balance.toInt()}");
    });
  }

  scanQrcode() async {
    FocusScope.of(context).unfocus();
    NavigatorUtils.pushTransparentPage(context,
        QRCodeScanner(scanComplete: (qrcode) {
      String qrAddress = qrcode.replaceFirst("ethereum:", "");
      setState(() {
        receiveAddress = qrAddress;
        textController.text = qrAddress;
      });
    }));
  }

  transfer(String key) async {
    EasyLoading.show();
    final client = Web3Client(ChainConfig.bep20.rpc, Client());
    final credentials = await client.credentialsFromPrivateKey(key);
    final fromAddress = EthereumAddress.fromHex(widget.lucidToken.address);
    final toAddress = EthereumAddress.fromHex(receiveAddress);
    final lucidContract = LucidContract(
        address: EthereumAddress.fromHex(widget.lucidToken.contract),
        client: client);
    String tx = await lucidContract.transfer(fromAddress, toAddress,
        BigInt.parse(widget.lucidItem.number), BigInt.from(transferAmount),
        credentials: credentials);
    transactionSuccess(tx);
    await client.dispose();
  }

  transactionSuccess(String tx) {
    print(tx);
    Navigator.of(context).pop();
    EasyLoading.showToast(S.of(context).successfully);
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
                      NaviBar(title: widget.lucidToken.name),
                      Gaps.vGap20,
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 15),
                                child: Text(S.of(context).receive_address,
                                    style: TextStyles.token_transfer_title)),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: CupertinoTextField(
                                        controller: textController,
                                        cursorHeight: 15,
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
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: LoadAssetImage(
                                            "dapp/dapp_scan",
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            scanQrcode();
                                          }),
                                    ],
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).transfer_amount,
                                        style: TextStyles.token_transfer_title),
                                    Text(
                                        S.of(context).transfer_available +
                                            ": ${widget.lucidToken.balance.toInt()}",
                                        style:
                                            TextStyles.token_transfer_available)
                                  ],
                                )),
                            ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    width: Screen.width - 40,
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
                                                    .allow(
                                                        RegExp(r"^[[1-9]\d*"))
                                              ],
                                              style: TextStyles
                                                  .token_transfer_amount,
                                              placeholderStyle: TextStyles
                                                  .token_transfer_place2,
                                              onChanged: (String textInput) {
                                                setState(() {
                                                  transferAmount = textInput ==
                                                          ""
                                                      ? 0
                                                      : int.parse(textInput);
                                                });
                                              },
                                            )),
                                            CupertinoButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: Text(
                                                  S.of(context).transfer_all,
                                                  style: TextStyles
                                                      .token_transfer_all,
                                                ),
                                                onPressed: () {
                                                  transferAll();
                                                })
                                          ],
                                        )
                                      ],
                                    ))),
                            Gaps.vGap32,
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
