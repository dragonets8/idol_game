import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:idol_game/abi/lucid.g.dart';
import 'package:idol_game/main/wallet/models/dreamcard_entity.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/pages/lucid_transfer_page.dart';
import 'package:idol_game/main/wallet/widgets/lucid_card.dart';
import 'package:idol_game/main/widgets/common_webview.dart';
import 'package:idol_game/main/widgets/custom_widgets.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frefresh/frefresh.dart';
import 'package:http/http.dart';
import 'package:idol_game/wallet_hd/config.dart';

class LucidListPage extends StatefulWidget {
  LucidListPage(
      {Key key, this.nftName, this.smartAddress, this.contractAddress})
      : super(key: key);

  final String nftName;
  final String smartAddress;
  final String contractAddress;
  @override
  LucidListState createState() => LucidListState();
}

class LucidListState extends State<LucidListPage> {
  List<LucidItem> lucidItems = [];
  FRefreshController controller = FRefreshController();
  TextEditingController textController = TextEditingController();
  String receiveAddress = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLucidCard();
    });
  }

  openDreamCardTransaction() {
    String exploreUrl =
        "https://bscscan.com/address/${widget.smartAddress}#tokentxnsErc1155";
    NavigatorUtils.pushTransparentPage(
        context, CommonWebView(title: "ERC-1155", initialUrl: exploreUrl));
  }

  getLucidCard() {
    List<LucidItem> lucids = [];
    List<String> lucidNumbers = ["515", "516", "769"];
    List<String> lucidNames = ["lucid magic", "lucid super", "lucid basic"];
    List<String> lucidImages = [
      "https://image.nft.xwg.games/tokens/9/515",
      "https://image.nft.xwg.games/tokens/9/516",
      "https://image.nft.xwg.games/tokens/9/769"
    ];
    for (var i = 0; i < lucidNumbers.length; i++) {
      LucidItem lucidItem = LucidItem(
          number: lucidNumbers[i],
          name: lucidNames[i],
          image: lucidImages[i],
          amount: "");
      lucids.add(lucidItem);
    }
    setState(() {
      lucidItems = lucids;
    });
    getLucidAmount();
  }

  getLucidAmount() async {
    EasyLoading.show();
    final client = Web3Client(ChainConfig.bep20.rpc, Client());
    print(widget.smartAddress);
    final ownerAddress = EthereumAddress.fromHex(widget.smartAddress);
    final lucidContract = LucidContract(
        address: EthereumAddress.fromHex(widget.contractAddress),
        client: client);
    for (var i = 0; i < lucidItems.length; i++) {
      String lucidId = lucidItems[i].number;
      var amount =
          await lucidContract.lucidBalance(ownerAddress, BigInt.parse(lucidId));
      setState(() {
        lucidItems[i].amount = "$amount";
      });
    }
    await client.dispose();
    controller.finishRefresh();
    EasyLoading.dismiss();
  }

  openLucidTransfer(LucidItem lucidItem) {
    TokenEntity lucidToken = TokenEntity(
        name: lucidItem.name,
        chain: "BEP20",
        chainName: "BSC",
        contract: widget.contractAddress,
        decimals: "1",
        address: widget.smartAddress,
        balance: double.parse(lucidItem.amount));
    NavigatorUtils.pushTransparentPage(context,
        LucidTransferPage(lucidItem: lucidItem, lucidToken: lucidToken));
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
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    lucidItems == null ? 0 : lucidItems.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.6,
                                ),
                                itemBuilder: (context, index) {
                                  return LucidCard(
                                      lucidItem: lucidItems[index],
                                      lucidClick: (lucidItem) {
                                        openLucidTransfer(lucidItem);
                                      });
                                },
                              ),
                              onRefresh: () {
                                getLucidCard();
                              }))
                    ],
                  ),
                )))));
  }
}
