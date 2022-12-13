import 'dart:io';
import 'package:flutter/services.dart';
import 'package:idol_game/database/token_database.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/provider/currency_provider.dart';
import 'package:idol_game/provider/locale_provider.dart';
import 'package:idol_game/services/storage_service.dart';
import 'package:idol_game/splash.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/single_child_widget.dart';
import 'database/dapp_database.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  await StorageService.init();
  WalletDB().connectDB();
  TokenDB().connectDB();
  DappDB().connectDB();
  configStatusBar();
  configLoading();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// 设置 Android 状态栏透明
configStatusBar() {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1200)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 32.0
    ..radius = 5.0
    ..progressColor = Colors.white
    ..backgroundColor = Colours.bg_color
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..textStyle = TextStyles.wallet_asset_title
    ..maskColor = Colors.black54.withOpacity(0.5)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false;
}

class MyApp extends StatefulWidget {
  static String currentLocale;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: LocaleProvider()),
        ChangeNotifierProvider.value(value: CurrencyProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (BuildContext context, localeModel, Widget child) {
          final loadingBuilder = EasyLoading.init();
          return CupertinoApp(
              navigatorKey: navigatorKey,
              title: "X Wallet",
              home: SplashPage(),
              debugShowCheckedModeBanner: false,
              theme: CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.white,
              ),
              builder: (context, child) => Scaffold(
                    body: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus.unfocus();
                        }
                      },
                      child: loadingBuilder(context, child),
                    ),
                  ),
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              locale: localeModel.locale,
              supportedLocales: S.delegate.supportedLocales);
        },
      ),
    );
  }
}
