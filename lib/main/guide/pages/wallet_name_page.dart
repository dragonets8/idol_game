import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/main/guide/pages/wallet_tips_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletNamePage extends StatefulWidget {
  WalletNamePage() : super();
  @override
  WalletNameState createState() => WalletNameState();
}

class WalletNameState extends State<WalletNamePage> {
  TextEditingController walletName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (BuildContext context) {
          return Container(height: 350, child: WalletTipsPage());
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
                    child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            color: Colors.white,
                            child: CupertinoTextField(
                              cursorHeight: 20,
                              placeholder: S.of(context).wallet_name_tips,
                              decoration: null,
                              maxLines: 1,
                              cursorColor: Colours.app_main,
                              style: TextStyles.token_name,
                              onChanged: (String textInput) {},
                            )),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  color: Colours.text_gray,
                                  child: Text(
                                    S.of(context).back,
                                    style: TextStyles.wallet_guide_button,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })),
                          SizedBox(
                            width: 60,
                          ),
                          Expanded(
                              child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  color: Colours.app_main,
                                  child: Text(
                                    S.of(context).confirm,
                                    style: TextStyles.wallet_guide_button,
                                  ),
                                  onPressed: () {
                                    showBottomSheet();
                                  })),
                        ],
                      )
                    ],
                  ),
                )))));
  }
}
