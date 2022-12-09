import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter/cupertino.dart';

class Buttons {
  static stateButton({String title, bool enable, Function() click}) {
    return Container(
        width: Screen.width - 40,
        child: CupertinoButton(
            padding: EdgeInsets.fromLTRB(30, 13, 30, 13),
            color: Colours.app_main,
            disabledColor: Colours.button_disabled,
            child: Text(
              title,
              style: TextStyles.dapp_sheet_button,
            ),
            onPressed: enable
                ? () {
                    click();
                  }
                : null));
  }

  static halfStateButton({String title, bool enable, Function() click}) {
    return CupertinoButton(
        padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
        minSize: 20,
        color: Colours.app_main,
        disabledColor: Colours.button_disabled,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Text(
          title,
          style: TextStyles.token_nft_button,
        ),
        onPressed: enable
            ? () {
                click();
              }
            : null);
  }
}
