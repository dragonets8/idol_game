import 'package:idol_game/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyWebView extends StatefulWidget {
  var title;
  var htmlPath;

  PolicyWebView({
    @required this.title,
    @required this.htmlPath,
  });

  @override
  CommonWebState createState() => CommonWebState();
}

class CommonWebState extends State<PolicyWebView> {
  WebViewController _webController;
  int loadProgress = 0;
  double progressHeight = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: naviBar(),
      body: SafeArea(
        child: Stack(children: [
          WebView(
            initialUrl: "",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) async {
              _webController = controller;
              loadHtml();
            },
            onProgress: (progress) {
              setState(() {
                loadProgress = progress;
                progressHeight = progress == 100 ? 0 : 2.0;
              });
            },
            onPageFinished: (str) {},
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
    );
  }

  loadHtml() async {
    String htmlContent = await rootBundle.loadString(widget.htmlPath);
    _webController.loadHtmlString(htmlContent);
  }

  Widget naviBar() {
    return AppBar(
      backgroundColor: Colours.bg_color,
      title: Container(
        child: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontSize: 18),
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
                Navigator.pop(context);
              });
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
