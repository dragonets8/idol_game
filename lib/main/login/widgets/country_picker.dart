import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class CountryPicker extends StatefulWidget {
  CountryPicker({Key key, this.selectCountry}) : super(key: key);

  final Function(Country) selectCountry;

  @override
  CountryPickerState createState() => CountryPickerState();
}

class CountryPickerState extends State<CountryPicker> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HalfWidthContainer(
            content: CupertinoPageScaffold(
                backgroundColor: Colours.bg_color,
                child: SafeArea(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            NaviBar(
                              title: S.of(context).select_country_title,
                            ),
                            Gaps.vGap20,
                            Expanded(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    child: Container(
                                      color: Colours.bg_dark,
                                      child: CountryPickerWidget(
                                          searchHintText: S
                                              .of(context)
                                              .search_country_placeholder,
                                          itemTextStyle:
                                              TextStyles.token_receive_button,
                                          searchInputStyle:
                                              TextStyles.token_receive_button,
                                          flagIconSize: 24,
                                          onSelected: (country) {
                                            widget.selectCountry(country);
                                            Navigator.of(context).pop();
                                          }),
                                    )))
                          ],
                        ))))));
  }
}
