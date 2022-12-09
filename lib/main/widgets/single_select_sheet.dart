import 'package:cached_network_image/cached_network_image.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:flutter/material.dart';

class SingleSelectSheet {
  static show(BuildContext context, String title, List<String> options,
      List<String> images, int selectIndex, Function(int) clickSheet,
      {bool isChain = false}) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  left: 15, right: Screen.width - Screen.height * 5 / 6 + 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: Container(
                      color: Colours.bg_color,
                      height: options.length * 40 + 80.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                              child: Text(
                                title,
                                style: TextStyles.naviTitle,
                              )),
                          Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int posion) {
                                    return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          clickSheet(posion);
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 12, 0, 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    isChain && posion > 0
                                                        ? CachedNetworkImage(
                                                            width: 20,
                                                            imageUrl:
                                                                images[posion],
                                                          )
                                                        : LoadAssetImage(
                                                            images[posion],
                                                            width: 20),
                                                    Gaps.hGap12,
                                                    Text(
                                                      options[posion],
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white70,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                                posion == selectIndex
                                                    ? LoadAssetImage("my/check",
                                                        width: 15)
                                                    : SizedBox(),
                                              ],
                                            )));
                                  })),
                        ],
                      ))));
        });
  }
}
