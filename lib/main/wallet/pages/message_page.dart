import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/wallet/pages/wallet_home_page.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MessagePage extends StatefulWidget {
  MessagePage() : super();
  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<MessagePage> {
  openHome() {
    NavigatorUtils.pushTransparentPage(context, WalletHomePage());
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: S.of(context).wallet_message),
                      Gaps.vGap15,
                      Container(
                        margin: const EdgeInsets.only(top: 50.0, bottom: 60.0),
                        child: LoadAssetImage('wallet/new_wallet', width: 100),
                      )
                    ],
                  ),
                )))));
  }
}
