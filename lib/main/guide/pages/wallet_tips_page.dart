import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WalletTipsPage extends StatefulWidget {
  // 构造函数
  WalletTipsPage({Key key}) : super(key: key);

  @override
  WalletTipsState createState() => WalletTipsState();
}

class WalletTipsState extends State<WalletTipsPage> {
  List content1 = [
    {
      'val':
          S.of(navigatorKey.currentState.overlay.context).create_wallet_tips_11,
      'size': 18.0,
      'height': 2,
      'fontColor': Colors.white,
      'fontWeight': FontWeight.w600
    },
    {
      'val':
          S.of(navigatorKey.currentState.overlay.context).create_wallet_tips_12,
      'size': 14.0,
      'height': 2,
      'fontColor': Colours.text_gray,
      'fontWeight': FontWeight.w400
    },
    {
      'val':
          S.of(navigatorKey.currentState.overlay.context).create_wallet_tips_13,
      'size': 14.0,
      'height': 2,
      'fontColor': Colours.text_gray,
      'fontWeight': FontWeight.w400
    },
  ];

  List content2 = [
    {
      'val':
          S.of(navigatorKey.currentState.overlay.context).create_wallet_tips_21,
      'size': 18.0,
      'height': 2,
      'fontColor': Colors.white,
      'fontWeight': FontWeight.w600
    },
    {
      'val':
          S.of(navigatorKey.currentState.overlay.context).create_wallet_tips_22,
      'size': 14.0,
      'height': 2,
      'fontColor': Colours.text_gray,
      'fontWeight': FontWeight.w400
    },
    {
      'val':
          S.of(navigatorKey.currentState.overlay.context).create_wallet_tips_23,
      'size': 14.0,
      'height': 2,
      'fontColor': Colours.text_gray,
      'fontWeight': FontWeight.w400
    }
  ];

  generateMnemonic() {
    Navigator.of(context).pop();
    EasyLoading.show();
    Future.delayed(const Duration(milliseconds: 500), () {
      bus.emit("guidetab", [1]);
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 30.0, right: 30.0), // 四周填充边距32像素
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: this
                .content1
                .map((data) => new Text(data['val'],
                    style: new TextStyle(
                        fontSize: data['size'],
                        color: data['fontColor'],
                        fontWeight: data['fontWeight'])))
                .toList(),
          ),
          SizedBox(
            height: 15.0,
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: this
                .content2
                .map((data) => new Text(data['val'],
                    style: new TextStyle(
                        fontSize: data['size'],
                        color: data['fontColor'],
                        fontWeight: data['fontWeight'])))
                .toList(),
          ),
          new SizedBox(
            height: 30.0,
          ),
          CupertinoButton(
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
              color: Colours.bg_dark,
              child: Text(
                S.of(context).confirm,
                style: TextStyles.wallet_guide_button,
              ),
              onPressed: () {
                generateMnemonic();
              }),
        ],
      ),
    );
  }
}
