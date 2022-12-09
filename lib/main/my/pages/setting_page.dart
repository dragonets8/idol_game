import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/main/widgets/single_select_sheet.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/provider/locale_provider.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage() : super();
  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<SettingPage> {
  final controller = AdvancedSwitchController();
  int languageIndex = LocaleProvider().localeIndex;
  int currencyIndex = CurrencyProvider().currencyIndex;
  List<String> languageTitles = ["English", "简体中文"];
  List<String> currencyTitles = ["USD", "CNY"];

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
                      NaviBar(title: S.of(context).my_setting),
                      Gaps.vGap20,
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: Screen.width - 30,
                              height: 45,
                              color: Colours.bg_dark,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Expanded(child: languageItem()),
                                    // Container(
                                    //   color: Colours.line,
                                    //   height: 0.8,
                                    // ),
                                    Expanded(child: currencyItem()),
                                    // Container(
                                    //   color: Colours.line,
                                    //   height: 0.8,
                                    // ),
                                    // Expanded(child: darkmodeItem()),
                                  ])))
                    ],
                  ),
                )))));
  }

  Widget languageItem() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          SingleSelectSheet.show(
              context,
              S.of(context).setting_language,
              languageTitles,
              ["my/language_english", "my/language_chinese"],
              LocaleProvider().localeIndex, (sheetIndex) {
            Provider.of<LocaleProvider>(context, listen: false)
                .switchLocale(sheetIndex);
            if (!mounted) return;
            setState(() {
              languageIndex = sheetIndex;
            });
          });
        },
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).setting_language,
              style: TextStyles.my_setting_title,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                languageTitles[languageIndex],
                style: TextStyles.my_setting_desc,
              ),
              Gaps.hGap8,
              LoadAssetImage("my/more_arrow", width: 20),
            ]),
          ],
        )));
  }

  Widget currencyItem() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          SingleSelectSheet.show(
              context,
              S.of(context).setting_currency,
              ["USD", "CNY"],
              ["my/currency_usd", "my/currency_cny"],
              CurrencyProvider().currencyIndex, (sheetIndex) {
            Provider.of<CurrencyProvider>(context, listen: false)
                .switchCurrency(sheetIndex);
            if (!mounted) return;
            setState(() {
              currencyIndex = sheetIndex;
            });
            bus.emit("switch_currency");
          });
        },
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).setting_currency,
              style: TextStyles.my_setting_title,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                currencyTitles[currencyIndex],
                style: TextStyles.my_setting_desc,
              ),
              Gaps.hGap8,
              LoadAssetImage("my/more_arrow", width: 20),
            ]),
          ],
        )));
  }

  Widget darkmodeItem() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).setting_dark,
              style: TextStyles.my_setting_title,
            ),
            AdvancedSwitch(
              controller: controller,
              activeColor: Color(0xff392358),
              inactiveColor: Colors.orange,
              activeChild: Icon(Ionicons.ios_moon),
              inactiveChild: Icon(Ionicons.ios_sunny),
              borderRadius: BorderRadius.all(const Radius.circular(12.5)),
              width: 54.0,
              height: 25.0,
              enabled: true,
              disabledOpacity: 0.5,
            )
          ],
        )));
  }
}
