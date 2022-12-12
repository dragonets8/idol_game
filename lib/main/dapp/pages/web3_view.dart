import 'dart:collection';
import 'dart:io';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/main/dapp/models/dapp_transaction.dart';
import 'package:idol_game/main/dapp/models/web3_utils.dart';
import 'package:idol_game/main/guide/pages/wallet_guide_page.dart';
import 'package:idol_game/main/wallet/pages/wallet_home_page.dart';
import 'package:idol_game/main/widgets/dapp_sheet.dart';
import 'package:idol_game/services/storage_service.dart';
import 'package:idol_game/splash.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/load_image.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/utils/security_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_floating/floating/assist/floating_slide_type.dart';
import 'package:flutter_floating/floating/floating.dart';
import 'package:http/http.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Web3View extends StatefulWidget {
  final DappConf dapp;
  final initialUrl;
  final address;
  final smartChain;
  final isFullscreen;

  Web3View(
      {@required this.dapp,
      @required this.initialUrl,
      @required this.address,
      @required this.smartChain,
      @required this.isFullscreen});

  @override
  _Web3ViewState createState() => _Web3ViewState();
}

class _Web3ViewState extends State<Web3View> {
  InAppWebViewController _web3Controller;
  int loadProgress = 0;
  double progressHeight = 2.0;
  Floating xwgFloating;
  bool isOpening = false;
  String currentAddress = "";

  @override
  void initState() {
    super.initState();
    bus.on("switchWeb3Wallet", (arg) {
      switchWeb3Wallet();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentAddress = widget.address;
      addXwgFloating();
      insertOverlay(context);
    });
  }

  switchWeb3Wallet() {
    WalletDB().queryWalletActivity((queryData) {
      currentAddress = queryData.length == 0 ? "" : queryData.first["smart"];
      _web3Controller.clearCache();
      _web3Controller.reload();
    });
  }

  addXwgFloating() {
    xwgFloating = Floating(
        navigatorKey,
        CupertinoButton(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: LoadAssetImage('common/float_xwg', width: 50),
            onPressed: () => {appLockJudge()}),
        slideType: FloatingSlideType.onRightAndTop,
        top: 30,
        isShowLog: false,
        moveOpacity: 0.7,
        slideTopHeight: 30);
    xwgFloating.open();
  }

  appLockJudge() {
    if (StorageService.shared.getBool("applock") ?? false) {
      SecurityUtils.showAuth(context, unlockHandler: (privateKey) {
        gotoHome();
      });
    } else {
      gotoHome();
    }
    setState(() {
      xwgFloating.close();
      isOpening = true;
    });
  }

  gotoHome() {
    WalletDB().queryWallet("active = 1", (queryData) {
      print(queryData.length);
      NavigatorUtils.pushTransparentPage(
          navigatorKey.currentState.overlay.context,
          queryData.length > 0
              ? WalletHomePage()
              : WalletGuidePage(isRoot: true));
    });
  }

  String hexToString(String hexString) {
    List<String> splitted = [];
    for (int i = 0; i < hexString.length; i = i + 2) {
      splitted.add(hexString.substring(i, i + 2));
    }
    String ascii = List.generate(splitted.length,
        (i) => String.fromCharCode(int.parse(splitted[i], radix: 16))).join();
    return ascii;
  }

  ethCall(List<dynamic> messages) async {
    int callbackId = messages[0];
    SmartChain smartChain = widget.smartChain;
    try {
      String recipient = messages[1];
      String payload = messages[2];
      final client = Web3Client(smartChain.rpc, Client());
      var bytes = hexToBytes(payload);
      var ret = await client.callRaw(
          sender: EthereumAddress.fromHex(currentAddress),
          contract: EthereumAddress.fromHex(recipient),
          data: bytes);
      callbackToJS(callbackId: callbackId, value: ret);
    } catch (e) {
      callbackToJS(callbackId: callbackId, error: e.toString());
    }
  }

  signPersonalMessage(List<dynamic> messages) async {
    int callbackId = messages[0];
    String signMessage = hexToString(messages[1].replaceFirst("0x", ""));
    DappSheet.signMessage(context, message: signMessage, clickAction: () {
      SecurityUtils.showAuth(context, unlockHandler: (privateKey) {
        EasyLoading.show();
        Web3Utils.signPersonalMessage(
            signMessage, privateKey, widget.smartChain, (signature) {
          callbackToJS(callbackId: callbackId, value: signature);
          EasyLoading.dismiss();
          Navigator.of(context).pop();
        });
      });
    }, cancelAction: () {
      callbackToJS(callbackId: callbackId, error: "cancelled");
    });
  }

  signTypedMessage(List<dynamic> messages) async {
    int callbackId = messages[0];
    String msg = messages[1];
    DappSheet.signMessage(context, message: msg, clickAction: () {
      SecurityUtils.showAuth(context, unlockHandler: (privateKey) {
        EasyLoading.show();
        String signature = EthSigUtil.signTypedData(
            privateKey: privateKey,
            jsonData: msg,
            version: TypedDataVersion.V4);
        callbackToJS(callbackId: callbackId, value: signature);
        EasyLoading.dismiss();
        Navigator.of(context).pop();
      });
    }, cancelAction: () {
      callbackToJS(callbackId: callbackId, error: "cancelled");
    });
  }

  processTransaction(List<dynamic> messages) async {
    int callbackId = messages[0];
    Map<String, dynamic> transactionJson = messages[1];
    DappTransaction transaction = DappTransaction.fromJson(transactionJson);
    Web3Utils.getEstimateGas(transaction, widget.smartChain, (estimateGas) {
      transaction.gas = transactionJson.keys.contains("gas")
          ? transaction.gas
          : estimateGas.toString();
      DappSheet.signTransaction(context, transaction: transaction,
          clickAction: () {
        SecurityUtils.showAuth(context, unlockHandler: (privateKey) {
          EasyLoading.show();
          Web3Utils.signTransaction(transaction, privateKey, widget.smartChain,
              (txid) {
            callbackToJS(callbackId: callbackId, value: txid);
            EasyLoading.dismiss();
            Navigator.of(context).pop();
          });
        });
      }, cancelAction: () {
        callbackToJS(callbackId: callbackId, error: "cancelled");
      });
    });
  }

  callbackToJS({@required int callbackId, String value, String error}) {
    var errorStr = error == null ? 'null' : '\"' + error + '\"';
    var valueStr = value == null ? 'null' : '\"' + value + '\"';
    var source = '''
    executeCallback($callbackId, $errorStr, $valueStr)
    ''';
    print(source);
    _web3Controller.evaluateJavascript(source: source);
  }

  List<String> getInjectJs() {
    String initJs = SplashPage.initJs;
    String walletJs = SplashPage.walletJs;
    SmartChain smartChain = widget.smartChain;
    initJs = initJs.replaceFirst("\$address", currentAddress);
    initJs = initJs.replaceFirst("\$rpcurl", smartChain.rpc);
    initJs = initJs.replaceFirst("\$chainId", smartChain.chainId.toString());
    return [walletJs, initJs];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: CupertinoPageScaffold(
        child: Stack(children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.initialUrl)),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true, cacheEnabled: true),
                android:
                    AndroidInAppWebViewOptions(useHybridComposition: true)),
            initialUserScripts: Platform.isIOS
                ? UnmodifiableListView<UserScript>([
                    UserScript(
                        source: getInjectJs()[0],
                        injectionTime:
                            UserScriptInjectionTime.AT_DOCUMENT_START),
                    UserScript(
                        source: getInjectJs()[1],
                        injectionTime:
                            UserScriptInjectionTime.AT_DOCUMENT_START),
                  ])
                : UnmodifiableListView<UserScript>([]),
            onWebViewCreated: (InAppWebViewController controller) {
              _web3Controller = controller;
              evaluateJavascript(_web3Controller);
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                loadProgress = progress;
                progressHeight = progress == 100 ? 0 : 2.0;
              });
            },
            onLoadStart: (controller, uri) {
              print(uri.toString());
              if (Platform.isAndroid) {
                _web3Controller.evaluateJavascript(source: getInjectJs()[0]);
                _web3Controller.evaluateJavascript(source: getInjectJs()[1]);
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
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
    );
  }

  evaluateJavascript(InAppWebViewController controller) {
    _web3Controller.addJavaScriptHandler(
        handlerName: "processTransaction",
        callback: (args) {
          print("processTransaction\n$args");
          processTransaction(args);
        });
    _web3Controller.addJavaScriptHandler(
        handlerName: "signMessage",
        callback: (args) {
          print("signMessage\n$args");
        });
    _web3Controller.addJavaScriptHandler(
        handlerName: "signPersonalMessage",
        callback: (args) {
          print("signPersonalMessage\n$args");
          signPersonalMessage(args);
        });
    _web3Controller.addJavaScriptHandler(
        handlerName: "signTypedMessage",
        callback: (args) {
          print("signTypedMessage\n$args");
          signTypedMessage(args);
        });
    _web3Controller.addJavaScriptHandler(
        handlerName: "ethCall",
        callback: (args) {
          print("ethCall\n$args");
          ethCall(args);
        });
    _web3Controller.addJavaScriptHandler(
        handlerName: "showWallet",
        callback: (args) {
          print("showWallet\n$args");
          appLockJudge();
        });
  }

  insertOverlay(BuildContext context) {
    return Overlay.of(context).insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        print(size.width);
        return !isOpening
            ? SizedBox()
            : Positioned(
                width: size.width - size.height * 5 / 6,
                height: size.height,
                left: size.height * 5 / 6,
                top: 0,
                child: Container(
                    color: Color(0x66111111),
                    alignment: AlignmentDirectional.topStart,
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: LoadAssetImage('common/xwg_close', height: 45),
                        minSize: 30,
                        onPressed: () {
                          setState(() {
                            xwgFloating.open();
                            isOpening = false;
                          });
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        })),
              );
      }),
    );
  }
}
