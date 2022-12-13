import 'dart:math';
import 'package:idol_game/abi/token.g.dart';
import 'package:idol_game/database/token_database.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/guide/models/guide_utils.dart';
import 'package:idol_game/main/guide/pages/wallet_guide_page.dart';
import 'package:idol_game/main/my/pages/my_page.dart';
import 'package:idol_game/main/wallet/models/token_config.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/pages/lucid_list_page.dart';
import 'package:idol_game/main/wallet/pages/message_page.dart';
import 'package:idol_game/main/wallet/pages/nft_list_page.dart';
import 'package:idol_game/main/wallet/pages/token_detail_page.dart';
import 'package:idol_game/main/wallet/pages/token_select_page.dart';
import 'package:idol_game/main/wallet/pages/wallet_list_page.dart';
import 'package:idol_game/main/wallet/widgets/wallet_switch.dart';
import 'package:idol_game/main/wallet/widgets/wallet_toolbar.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/single_select_sheet.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:idol_game/wallet_hd/token_utils/string_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol_game/main/widgets/custom_widgets.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/main/wallet/widgets/token_cell.dart';
import 'package:idol_game/main/wallet/widgets/wallet_panel.dart';
import 'package:frefresh/frefresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class WalletHomePage extends StatefulWidget {
  WalletHomePage() : super();
  @override
  WalletHomeState createState() => WalletHomeState();
}

class WalletHomeState extends State<WalletHomePage>
    with AutomaticKeepAliveClientMixin {
  FRefreshController controller = FRefreshController();
  List<TokenEntity> selectTokens = [];
  List<TokenEntity> tokenList = [];
  List<String> valuableTokens = [];
  String smartAddress = "";
  String currentWallet = "";
  int currentFilter = 0;
  List<String> filterChains = ["", "BEP20", "BTC", "ERC20", "HRC20"];
  Map<String, dynamic> legalPrice;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshTokens();
    });
    bus.on("switch_wallet", (args) {
      updateMyTokens();
    });
    bus.on("switch_currency", (args) {
      refreshLegalPrice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    controller.finishRefresh();
  }

  refreshTokens() {
    WalletDB().queryWallet("active = 1", (walletData) async {
      String ethAddress = walletData.first["smart"];
      smartAddress = ethAddress;
      for (var i = 0; i < tokenConfig.length; i++) {
        Map<String, dynamic> tokenMap = tokenConfig[i].toJson();
        TokenDB().refeshToken(walletData.first, tokenMap,
            isLast: i == tokenConfig.length - 1, complete: () {
          updateMyTokens();
          EasyLoading.dismiss();
        });
      }
    });
  }

  updateMyTokens() {
    WalletDB().queryWallet("active = 1", (walletData) async {
      String ethAddress = walletData.first["smart"];
      smartAddress = ethAddress;
      TokenDB().queryToken("id > 0", (tokenData) {
        Map<String, dynamic> tokenMap = {"list": tokenData};
        TokenEntityList tokenEntityList = TokenEntityList.fromJson(tokenMap);
        selectTokens = tokenEntityList.list
            .where((element) => element.isSelect == 1)
            .toList();
        setState(() {
          tokenList = selectTokens;
          currentWallet = walletData.first["name"];
        });
        getTokenBalance(ethAddress);
        GuideUtils.bindAddress(
            walletData.first["smart"], currentWallet, walletData.first["type"]);
      });
    });
  }

  getTokenBalance(String address) async {
    valuableTokens.clear();
    for (TokenEntity tokenItem in tokenList) {
      if (tokenItem.contract == "") {
        final client = Web3Client(ChainConfig.bep20.rpc, Client());
        client.getBalance(EthereumAddress.fromHex(address)).then((value) {
          BigInt balance = value.getValueInUnitBI(EtherUnit.wei);
          double tokenBalance =
              balance.toInt() / pow(10, int.parse(tokenItem.decimals));
          print(tokenBalance);

          refreshTokenBalance(tokenItem, tokenBalance);
        });
        await client.dispose();
      } else {
        final client = Web3Client(ChainConfig.bep20.rpc, Client());
        final tokenContract = TokenContract(
            address: EthereumAddress.fromHex(tokenItem.contract),
            client: client,
            chainId: ChainConfig.bep20.chainId);
        tokenContract
            .getBalance(EthereumAddress.fromHex(address))
            .then((balance) {
          double tokenBalance =
              bigNum2Double(balance, int.parse(tokenItem.decimals));
          print(tokenBalance);
          refreshTokenBalance(tokenItem, tokenBalance);
        });
        await client.dispose();
      }
    }
  }

  refreshTokenBalance(TokenEntity tokenItem, double balance) {
    valuableTokens.add("${tokenItem.id}");
    if (!mounted) return;
    setState(() {
      tokenList
          .where((element) =>
              element.name == tokenItem.name &&
              element.chain == tokenItem.chain)
          .toList()[0]
          .balance = double.parse(balance.toStringAsFixed(6));
    });
    if (valuableTokens.length == tokenList.length - 1) {
      getLegalPrice();
    }
  }

  getLegalPrice() async {
    List<String> geckoList = [];
    tokenList.forEach((token) {
      geckoList.add(token.coingecko);
    });
    Map<String, dynamic> parama = {
      "ids": geckoList.join(","),
      "vs_currencies": "btc,usd,cny",
    };
    DioManager().request<Map<String, dynamic>>(Apis.getPriceRate,
        params: parama, success: (response) {
      legalPrice = response["map"];
      refreshLegalPrice();
    }, error: (error) {
      print(error.message);
    });
  }

  refreshLegalPrice() {
    if (legalPrice == null) {
      return;
    }
    if (legalPrice.length > 0) {
      for (var i = 0; i < tokenList.length; i++) {
        TokenEntity tokenItem = tokenList[i];
        setState(() {
          tokenItem.btcPrice =
              double.parse(legalPrice[tokenItem.coingecko]["btc"].toString());
          tokenItem.usdPrice =
              double.parse(legalPrice[tokenItem.coingecko]["usd"].toString());
          tokenItem.cnyPrice =
              double.parse(legalPrice[tokenItem.coingecko]["cny"].toString());
          tokenItem.legalBalance = doubleDecimals(tokenItem.balance *
              (CurrencyProvider().currencyIndex == 1
                  ? tokenItem.cnyPrice
                  : tokenItem.usdPrice));
        });
      }
      EasyLoading.dismiss();
      controller.finishRefresh();
    }
  }

  double doubleDecimals(double value) {
    int decimals = 2;
    int fac = pow(10, decimals);
    value = (value * fac).round() / fac;
    return value;
  }

  openOption(int optionIndex) {
    List optionPages = [
      TokenSelectPage(myTokens: tokenList, selectType: TokenSelectType.receive),
      TokenSelectPage(
          myTokens: tokenList, selectType: TokenSelectType.transfer),
    ];
    NavigatorUtils.pushTransparentPage(context, optionPages[optionIndex]);
  }

  openNFT() {
    List nftContracts = [
      ContractConfig.lucid.bep20,
      ContractConfig.dreamcard.bep20,
      ContractConfig.xeqp.bep20
    ];
    List<String> nftNames = ["Lucid", "Dream Card", "DC Equipment"];
    List<String> nftImages = [
      "wallet/lucid_card",
      "wallet/nft_card",
      "wallet/nft_xeqp"
    ];
    SingleSelectSheet.show(
        context, S.of(context).nft_list, nftNames, nftImages, -1, (sheetIndex) {
      NavigatorUtils.pushTransparentPage(
          context,
          sheetIndex == 0
              ? LucidListPage(
                  nftName: nftNames[sheetIndex],
                  smartAddress: smartAddress,
                  contractAddress: nftContracts[sheetIndex])
              : NFTListPage(
                  nftName: nftNames[sheetIndex],
                  smartAddress: smartAddress,
                  contractAddress: nftContracts[sheetIndex]));
    });
  }

  openMy() {
    NavigatorUtils.pushTransparentPage(context, MyPage());
  }

  addWallet() {
    NavigatorUtils.pushTransparentPage(context, WalletGuidePage(isRoot: false));
  }

  manageWallet() {
    NavigatorUtils.pushTransparentPage(context, WalletListPage());
  }

  openMessage() {
    NavigatorUtils.pushTransparentPage(context, MessagePage());
  }

  openTokenDetail(TokenEntity tokenItem) {
    NavigatorUtils.pushTransparentPage(
        context, TokenDetailPage(tokenItem: tokenItem));
  }

  openWalletSwitch() {
    WalletDB().queryWallet("id > 0", (queryData) {
      WalletSwitch.sheet(context, queryData, () {
        manageWallet();
      }, () {
        addWallet();
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WalletToolBar(
                          walletTitle: currentWallet,
                          switchClick: () {
                            openWalletSwitch();
                          },
                          nftClick: () {
                            openNFT();
                          },
                          myClick: () {
                            openMy();
                          },
                          messageClick: () {
                            openMessage();
                          }),
                      Expanded(
                          child: FRefresh(
                        controller: controller,
                        header: CustomWidgets.refreshHeader(50),
                        headerHeight: 50.0,
                        child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tokenList.length + 2,
                                itemBuilder: (BuildContext context, int index) {
                                  return walletListItem(index);
                                })),
                        onRefresh: () {
                          getTokenBalance(smartAddress);
                        },
                      )),
                    ],
                  ),
                ))));
  }

  Widget walletListItem(int itemIndex) {
    if (itemIndex == 0) {
      return Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: WalletPanel(
            tokenList: tokenList,
            optionClick: (clickIndex) {
              openOption(clickIndex);
            },
          ));
    } else if (itemIndex == 1) {
      return Gaps.vGap10;
    } else {
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TokenCell(
              tokenItem: tokenList[itemIndex - 2],
              tokenClick: (tokenName) {
                openTokenDetail(tokenList[itemIndex - 2]);
              }));
    }
  }
}
