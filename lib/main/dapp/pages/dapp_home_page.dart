import 'dart:async';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/main/dapp/models/ads_entity.dart';
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/main/dapp/widgets/chain_dapp.dart';
import 'package:idol_game/main/dapp/widgets/my_dapp.dart';
import 'package:idol_game/main/dapp/widgets/top_dapp.dart';
import 'package:idol_game/main/dapp/pages/web3_view.dart';
import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:idol_game/main/widgets/common_webview.dart';
import 'package:idol_game/main/widgets/dapp_sheet.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/provider/locale_provider.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:idol_game/widgets/banner_carousel/banner_model.dart';
import 'package:idol_game/widgets/banner_carousel/banners_carousel.dart';
import 'package:idol_game/widgets/banner_carousel/indicator_model.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tab_bar/custom_tab_bar_lib.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class DappHomePage extends StatefulWidget {
  DappHomePage() : super();
  @override
  DappHomeState createState() => DappHomeState();
}

class DappHomeState extends State<DappHomePage>
    with AutomaticKeepAliveClientMixin {
  List<String> tabTitles = [
    S.of(navigatorKey.currentState.overlay.context).dapp_recommend,
    S.of(navigatorKey.currentState.overlay.context).dapp_my,
  ];
  List<Ad> ads = [];
  List<BannerModel> listBanner = [];
  final PageController pageController = PageController();

  final ExpandableListController expandableController =
      ExpandableListController();
  StandardIndicatorController indicatorController =
      StandardIndicatorController();

  DappEntity allDapps;
  PageController _pageController;
  Timer _timer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getAdds();
    getDapps();
    addBannerTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  addBannerTimer() {
    _pageController = PageController(
      initialPage: 0,
    );
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) {
        if (_pageController.page == 3.0) {
          _pageController.jumpTo(0);
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }

  getAdds() {
    DioManager().request<AdsEntity>(Apis.queryAds, params: {},
        success: (adsEntity) {
      ads = adsEntity.ads;
      List<BannerModel> banners = [];
      for (var i = 0; i < ads.length; i++) {
        Ad ad = ads[i];
        BannerModel bannerModel = BannerModel(
            imagePath:
                LocaleProvider().localeIndex > 0 ? ad.imageCn : ad.imageEn,
            id: "$i");
        banners.add(bannerModel);
      }
      setState(() {
        listBanner = banners;
      });
    }, error: (error) {
      print(error.message);
    });
  }

  getDapps() {
    DioManager().request<DappEntity>(Apis.queryDappConfs, params: {},
        success: (dappEntity) {
      setState(() {
        allDapps = dappEntity;
      });
    }, error: (error) {
      print(error.message);
    });
  }

  openAd(Ad ad) {
    String adUrl = LocaleProvider().localeIndex > 0 ? ad.linkCn : ad.linkEn;
    NavigatorUtils.pushTransparentPage(
        context, CommonWebView(title: ad.name, initialUrl: adUrl));
  }

  openDapp(DappConf dapp) {
    EasyLoading.show();
    WalletDB().queryWallet("active = 1", (queryData) {
      Map<String, dynamic> activeWallet = queryData.first;
      SmartChain smartChain = smartChainMap[dapp.chainName];
      DappSheet.openDapp(context, dapp: dapp, clickAction: () {
        NavigatorUtils.pushTransparentPage(
            context,
            Web3View(
                dapp: dapp,
                initialUrl: dapp.url,
                address: activeWallet["smart"],
                smartChain: smartChain,
                isFullscreen: false));
      });
      EasyLoading.dismiss();
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
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                          child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            child: Container(
                              height: (Screen.width - 40) / 3,
                              child: BannerCarousel(
                                banners: listBanner,
                                margin: EdgeInsets.zero,
                                borderRadius: 10,
                                activeColor: Colours.app_main,
                                pageController: _pageController,
                                customizedIndicators: IndicatorModel.animation(
                                    width: 6, height: 6, spaceBetween: 5.0),
                                onTap: (id) {
                                  openAd(ads[int.parse(id)]);
                                },
                              ),
                            )),
                      )),
                      SliverExpandableList(
                        builder:
                            SliverExpandableChildDelegate<Widget, DappSection>(
                                sectionList: getDappSections(),
                                headerBuilder: (BuildContext context,
                                    int sectionIndex, int index) {
                                  return ExpandableAutoLayoutWidget(
                                      trigger:
                                          ExpandableDefaultAutoLayoutTrigger(
                                              expandableController),
                                      builder: (context) {
                                        return tabTitles.length > 2
                                            ? getChainTabbar()
                                            : SizedBox();
                                      });
                                },
                                controller: expandableController,
                                itemBuilder:
                                    (context, sectionIndex, itemIndex, index) {
                                  return getDappSections()[sectionIndex]
                                      .items[itemIndex];
                                }),
                      )
                    ],
                  ),
                ))));
  }

  List<DappSection> getDappSections() {
    var sections = List<DappSection>.empty(growable: true);
    var section = DappSection()
      ..header = Text("data")
      ..items = List.generate(1, (index) {
        return ExpandablePageView(
            controller: pageController,
            estimatedPageSize: 100,
            itemCount: tabTitles.length,
            itemBuilder: (context, index) {
              return buildDappPage(index);
            });
      })
      ..expanded = true;
    sections.add(section);
    return sections;
  }

  Widget buildDappPage(int tabIndex) {
    if (tabIndex == 0) {
      return TopDapp(
          dappEntity: allDapps,
          dappClick: (dapp) {
            openDapp(dapp);
          });
    } else if (tabIndex == 1) {
      return MyDapp(dappClick: (dapp) {
        openDapp(dapp);
      });
    } else {
      return ChainDapp(
          chain: tabTitles[tabIndex],
          dappEntity: allDapps,
          dappClick: (dapp) {
            openDapp(dapp);
          });
    }
  }

  Widget getChainTabbar() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 35,
      child: CustomTabBar(
        defaultPage: 0,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tabTitles.length,
        backgroundColor: Colours.bg_color,
        builder: getTabbarChild,
        indicator: StandardIndicator(
          indicatorWidth: 30,
          indicatorColor: Colours.app_main,
          controller: indicatorController,
        ),
        pageController: pageController,
        tabbarController: indicatorController,
      ),
    );
  }

  Widget getTabbarChild(BuildContext context, TabBarItemInfo data) {
    return TabBarItem(
        tabbarItemInfo: data,
        delegate: ScaleTransformDelegate(
            maxScale: 1.1,
            delegate: ColorTransformDelegate(
              normalColor: Colors.white,
              highlightColor: Colours.app_main,
              builder: (context, color) {
                return Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minWidth: 60),
                    child: (Text(
                      tabTitles[data.itemIndex],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    )));
              },
            )));
  }

  Widget buildSearchBar() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        child: Container(
                          alignment: AlignmentDirectional.centerStart,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: Colours.line,
                          height: 42,
                          child: Text(
                            "请输入DApp名称或网络连接",
                            style: TextStyles.dapp_search_place,
                          ),
                        )))),
            CupertinoButton(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: LoadAssetImage(
                  "dapp/dapp_scan",
                  width: 20,
                ),
                onPressed: () {})
          ],
        ));
  }
}

class DappSection implements ExpandableListSection<Widget> {
  bool expanded;
  List<Widget> items;
  Widget header;

  @override
  List<Widget> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}
