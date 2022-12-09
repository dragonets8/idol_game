import 'dart:convert';
import 'dart:io';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/models/dreamcard_entity.dart';
import 'package:idol_game/main/wallet/models/nft_tool.dart';
import 'package:idol_game/main/wallet/pages/nft_history_page.dart';
import 'package:idol_game/main/wallet/widgets/nft_card.dart';
import 'package:idol_game/main/widgets/custom_widgets.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/input_sheet.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/qrcode_scanner.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:idol_game/utils/valid_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frefresh/frefresh.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class NFTListPage extends StatefulWidget {
  NFTListPage({Key key, this.nftName, this.smartAddress, this.contractAddress})
      : super(key: key);

  final String nftName;
  final String smartAddress;
  final String contractAddress;
  @override
  NFTListState createState() => NFTListState();
}

class NFTListState extends State<NFTListPage> {
  int cardAmount = 0;
  int totalPages = 0;
  int currentPage = 0;
  List<NFTItem> nftItems = [];
  FRefreshController controller = FRefreshController();
  TextEditingController textController = TextEditingController();
  String receiveAddress = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCardAmount();
    });
  }

  openDreamCardTransaction() {
    NavigatorUtils.pushTransparentPage(
        context,
        NFTHistoryPage(
            cardAddress: widget.smartAddress,
            contractAddress: widget.contractAddress));

    // List<String> transferCards = [];
    // for (var i = 0; i < transferCards.length; i++) {
    //   Future.delayed(Duration(seconds: i * 1 + 1), () {
    //     NFTTool.transfer("", "0x735B89eB5866EBf1c87D74B267965BECfb3919e7",
    //         "", transferCards[i], (tx) {
    //       print(tx);
    //     });
    //   });
    // }
  }

  getCardAmount() {
    EasyLoading.show();
    NFTTool.nftAmount(widget.smartAddress, widget.contractAddress,
        (cardBlance) {
      EasyLoading.dismiss();
      if (cardBlance.toInt() == 0) {
        EasyLoading.dismiss();
        controller.finishRefresh();
        controller.finishLoad();
        return;
      } else {
        cardAmount = cardBlance.toInt();
        totalPages = (cardAmount / 30).ceil().toInt();
        getDreamCard(true);
      }
    });
  }

  scanQrcode() async {
    NavigatorUtils.pushTransparentPage(context,
        QRCodeScanner(scanComplete: (qrcode) {
      String qrAddress = qrcode.replaceFirst("ethereum:", "");
      setState(() {
        receiveAddress = qrAddress;
        textController.text = qrAddress;
      });
    }));
  }

  showTransferDialog(String cardId) {
    InputSheet.show(context,
        title: S.of(context).nft_receive_address,
        placeholder: S.of(context).nft_receive_address_tips,
        editController: textController,
        inputHandler: (input) {
          receiveAddress = input;
        },
        completeHandler: () {
          transferCard(cardId);
        },
        excessButton: true,
        excessHandler: () {
          scanQrcode();
        });
  }

  transferCard(String cardId) {
    if (ValidUtils.isEthAddress(receiveAddress)) {
      SecurityUtils.showAuth(context, unlockHandler: (privateKey) {
        EasyLoading.show();
        NFTTool.transfer(privateKey, widget.contractAddress,
            widget.smartAddress, receiveAddress, cardId, (tx) {
          Future.delayed(Duration(seconds: 3), () {
            print("交易ID：$tx");
            EasyLoading.showToast(S.of(context).successfully);
            Navigator.of(context).pop();
            setState(() {
              nftItems.removeWhere((element) => element.number == cardId);
            });
          });
        });
      });
    } else {
      EasyLoading.showToast(S.of(context).nft_receive_address_wrong);
    }
  }

  getDreamCard(bool isRefresh) {
    EasyLoading.show();
    int pageSize = 30;
    if (isRefresh) {
      currentPage = 0;
      nftItems.clear();
    }
    if (currentPage == totalPages - 1) {
      pageSize = cardAmount % pageSize == 0 ? pageSize : cardAmount % pageSize;
    }
    if (currentPage == totalPages) {
      nftItems.sort((left, right) => left.name.compareTo(right.name));
      if (!isRefresh) {
        EasyLoading.dismiss();
        controller.finishLoad();
        controller.finishRefresh();
        return;
      }
    }
    List<NFTItem> nftList = [];
    print("总页数：$totalPages，请求页数：$currentPage，页数量：$pageSize");
    Client sslClient() {
      var ioClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      Client _client = IOClient(ioClient);
      return _client;
    }

    for (var i = currentPage * 30; i < currentPage * 30 + pageSize; i++) {
      NFTTool.nftId(widget.smartAddress, widget.contractAddress, BigInt.from(i),
          (nftId) async {
        NFTTool.nftUrl(widget.contractAddress, nftId, (nftUrl) async {
          try {
            var response = await sslClient().get(Uri.parse(nftUrl));
            NFTItem nftItem = NFTItem.fromJson(jsonDecode(response.body));
            nftItem.number = nftId.toString();
            nftList.add(nftItem);
            if (nftList.length == pageSize) {
              nftList.sort((left, right) => left.image
                  .split('/')
                  .last
                  .compareTo(right.image.split('/').last));
              nftItems.addAll(nftList);
              currentPage = isRefresh ? 1 : currentPage + 1;
              EasyLoading.dismiss();
              controller.finishLoad();
              controller.finishRefresh();
              if (!mounted) return;
              setState(() {
                nftItems = nftItems;
              });
            }
          } catch (e) {}
        });
      });
    }
  }

  requestDreamCard(String cardSerial, int pageSize, bool isRefresh) async {}

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
                      NaviBar(
                          title: widget.nftName,
                          itemImage: "wallet/nft_history",
                          itemClick: () {
                            openDreamCardTransaction();
                          }),
                      Gaps.vGap10,
                      Expanded(
                          child: FRefresh(
                        controller: controller,
                        header: CustomWidgets.refreshHeader(40),
                        headerHeight: 40.0,
                        footer: Text("加载中...",
                            textAlign: TextAlign.center,
                            style: TextStyles.token_name),
                        footerHeight: 50.0,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: nftItems.length,
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return NftCard(
                                nftItem: nftItems[index],
                                nftClick: (nftItem) {
                                  showTransferDialog(nftItem.number);
                                });
                          },
                        ),
                        onRefresh: () {
                          getCardAmount();
                        },
                        onLoad: () {
                          getDreamCard(false);
                        },
                      ))
                    ],
                  ),
                )))));
  }
}
