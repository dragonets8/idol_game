import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:idol_game/utils/load_image.dart';

class AboutPage extends StatefulWidget {
  AboutPage() : super();
  @override
  AboutState createState() => AboutState();
}

class AboutState extends State<AboutPage> {
  String appInfo = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPackageInfo();
    });
  }

  getPackageInfo() async {
    String version = await AzhonAppUpdate.getVersionName;
    int buildNumber = await AzhonAppUpdate.getVersionCode;
    setState(() {
      appInfo = "v$version - $buildNumber";
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NaviBar(title: S.of(context).my_about),
                      Gaps.vGap32,
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        child: LoadAssetImage("common/xwg_logo",
                            width: Screen.width / 6),
                      ),
                      Gaps.vGap15,
                      Text(
                        appInfo,
                        style: TextStyles.token_detail_button,
                      )
                    ],
                  ),
                )))));
  }
}
