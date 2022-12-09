import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/main/widgets/navi_bar.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/gaps.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage() : super();
  @override
  FeedbackState createState() => FeedbackState();
}

class FeedbackState extends State<FeedbackPage> {
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
                      NaviBar(title: S.of(context).my_feedback),
                      Gaps.vGap20,
                      ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              width: Screen.width - 40,
                              color: Colours.bg_dark,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context).my_feedback,
                                      style: TextStyles.naviTitle,
                                    )
                                  ])))
                    ],
                  ),
                )))));
  }
}
