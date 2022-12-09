import 'package:idol_game/main/widgets/halfwidth_container.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CommonWebView extends StatefulWidget {
  var title;
  var initialUrl;

  CommonWebView({
    @required this.title,
    @required this.initialUrl,
  });

  @override
  CommonWebState createState() => CommonWebState();
}

class CommonWebState extends State<CommonWebView> {
  InAppWebViewController _webController;
  int loadProgress = 0;
  double progressHeight = 2.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HalfWidthContainer(
            content: Scaffold(
          appBar: naviBar(),
          body: SafeArea(
            child: Stack(children: [
              InAppWebView(
                initialUrlRequest:
                    URLRequest(url: Uri.parse(widget.initialUrl)),
                initialOptions: InAppWebViewGroupOptions(
                    android:
                        AndroidInAppWebViewOptions(useHybridComposition: true)),
                onWebViewCreated: (controller) {
                  _webController = controller;
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    loadProgress = progress;
                    progressHeight = progress == 100 ? 0 : 2.0;
                  });
                },
              ),
              SizedBox(
                height: progressHeight,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colours.app_main),
                  value: loadProgress / 100,
                ),
              ),
            ]),
          ),
        )));
  }

  Widget naviBar() {
    return AppBar(
      backgroundColor: Colours.bg_color,
      title: Container(
        child: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            iconSize: 18,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              _webController.canGoBack().then((isBack) {
                if (isBack) {
                  _webController.goBack();
                } else {
                  Navigator.pop(context);
                }
              });
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      actions: <Widget>[
        IconButton(
          iconSize: 18,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      centerTitle: true,
      elevation: 0,
    );
  }
}
