import 'package:flutter/cupertino.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/load_image.dart';

class NaviBar extends StatelessWidget {
  const NaviBar(
      {Key key,
      this.title,
      this.itemTitle = "",
      this.itemImage = "",
      this.canGoBack = true,
      this.itemClick})
      : super(key: key);

  final String title;
  final String itemTitle;
  final String itemImage;
  final bool canGoBack;
  final Function() itemClick;

  goBack() {
    BuildContext context = navigatorKey.currentState.overlay.context;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                canGoBack
                    ? CupertinoButton(
                        alignment: AlignmentDirectional.centerStart,
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        minSize: 30,
                        child: LoadAssetImage('common/back', width: 20),
                        onPressed: () => {goBack()})
                    : SizedBox(),
              ],
            )),
            Container(
              width: Screen.height * 5 / 12,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.naviTitle,
              ),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                itemTitle == ""
                    ? SizedBox()
                    : CupertinoButton(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        minSize: 10,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Text(
                          itemTitle,
                          style: TextStyles.navi_item,
                          textAlign: TextAlign.end,
                        ),
                        onPressed: () => {itemClick()}),
                itemImage == ""
                    ? SizedBox()
                    : Container(
                        child: CupertinoButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: LoadAssetImage(
                              itemImage,
                              width: 20,
                            ),
                            onPressed: () => {itemClick()}))
              ],
            )),
          ],
        ));
  }
}
