import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/provider/locale_provider.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/styles.dart';

class DappCell extends StatelessWidget {
  const DappCell({Key key, this.dapp, this.isLast, this.dappClick})
      : super(key: key);

  final DappConf dapp;
  final bool isLast;
  final Function(DappConf) dappClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          dappClick(dapp);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        width: 35,
                        imageUrl: dapp.image,
                      ),
                      Gaps.hGap15,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleProvider().localeIndex > 0
                                ? dapp.nameCn
                                : dapp.nameEn,
                            style: TextStyles.dapp_name,
                          ),
                          Gaps.vGap3,
                          Row(
                            children: [
                              tagText(dapp.chainName, Colours.bg_color, false),
                              Gaps.hGap8,
                              tagText(
                                  dapp.tag == "" ? "" : dappTagMapEn[dapp.tag],
                                  Colours.text_disabled,
                                  true),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Gaps.vGap8,
                  Container(
                    width: Screen.width - 120,
                    child: Text(
                      LocaleProvider().localeIndex > 0
                          ? dapp.introductionCn
                          : dapp.introductionEn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colours.text_gray,
                        fontFamily: "D-DIN",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]),
                Gaps.hGap20,
                LoadAssetImage("my/more_arrow", width: 16),
              ],
            ),
            isLast ? Gaps.vGap10 : Gaps.vGap15,
            isLast
                ? SizedBox()
                : Container(
                    height: 0.6,
                    color: Colours.line,
                  )
          ]),
        ));
  }

  Widget tagText(String tagName, Color tagColor, bool highlight) {
    return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
        child: Container(
          height: 18,
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          alignment: AlignmentDirectional.center,
          color: tagColor,
          child: Text(
            tagName,
            style: highlight
                ? TextStyles.dapp_tagtext_light
                : TextStyles.dapp_tagtext_dark,
          ),
        ));
  }
}
