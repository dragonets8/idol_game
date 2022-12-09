import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/styles/gaps.dart';

class TopDapp extends StatelessWidget {
  const TopDapp({Key key, this.dappEntity, this.dappClick}) : super(key: key);

  final DappEntity dappEntity;
  final Function(DappConf) dappClick;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
            child: Container(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                width: Screen.width - 40,
                color: Colours.bg_dark,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topDappPanel("X World Games",
                          dappEntity == null ? [] : dappEntity.dappConfs["1"],
                          (clickDapp) {
                        dappClick(clickDapp);
                      }),
                      topDappPanel(S.of(context).dapp_hot,
                          dappEntity == null ? [] : dappEntity.dappConfs["2"],
                          (clickDapp) {
                        dappClick(clickDapp);
                      })
                    ]))));
  }

  Widget topDappPanel(
      String topName, List<DappConf> dapps, Function(DappConf) clickDapp) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Gaps.hGap15,
                Text(topName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: "D-DIN",
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            Gaps.vGap20,
            GridView.builder(
              shrinkWrap: true,
              itemCount: dapps.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return dappItem(dapps, index, (dapp) {
                  clickDapp(dapps[index]);
                });
              },
            )
          ],
        ));
  }

  Widget dappItem(
      List<DappConf> dapps, int dappIndex, Function(DappConf) clickDapp) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          clickDapp(dapps[dappIndex]);
        },
        child: Column(children: [
          CachedNetworkImage(
            width: 42,
            imageUrl: dapps[dappIndex].image,
          ),
          Gaps.vGap8,
          Text(
            dapps[dappIndex].nameEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colours.text_gray,
              fontFamily: "D-DIN",
              fontWeight: FontWeight.w500,
            ),
          ),
        ]));
  }
}
