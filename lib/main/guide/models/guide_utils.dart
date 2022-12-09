import 'dart:convert';
import 'dart:io';

import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/database/wallet_entity.dart';
import 'package:idol_game/main/wallet/pages/wallet_home_page.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/utils/encrypt_utils.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class GuideUtils {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static gotoHome(BuildContext context, WalletEntity wallet, String password) {
    WalletDB().addWalletWith(wallet, EncryptUtils.stringToKey(password),
        (walletId) {
      String walletName = wallet.type == 0
          ? wallet.name
          : "wallet_" + NumberFormat("000", "en_US").format(walletId);
      WalletDB().renameWallet(walletId, walletName);
      WalletDB().activeWallet(walletId);
      NavigatorUtils.pushTransparentPage(context, WalletHomePage());
      bindAddress(wallet.smart, walletName, wallet.type);
      bus.emit("switchWeb3Wallet");
    });
  }

  static bindAddress(
      String walletAddress, String walletName, int walletType) async {
    getDevideInfo().then((deviceInfo) async {
      deviceInfo["address"] = walletAddress;
      deviceInfo["addressName"] = walletName;
      deviceInfo["clientNo"] = "01";
      deviceInfo["method"] = walletType;
      deviceInfo["channel"] = 1;
      DioManager().request<dynamic>(Apis.bindAddress, params: deviceInfo,
          success: (data) {
        print("deviceInfo" + deviceInfo.toString());
      }, error: (error) {
        print(error.message);
      });
    });
  }

  static Future<Map<String, dynamic>> getDevideInfo() async {
    var deviceData = <String, dynamic>{};
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    }
    if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
    var ipUrl = 'http://ip-api.com/json';
    try {
      var response = await http.get(Uri.parse(ipUrl));
      Map<String, dynamic> ipInfo = jsonDecode(response.body);
      deviceData["deviceIp"] = ipInfo["query"];
      return deviceData;
    } catch (e) {
      deviceData["deviceIp"] = "";
      return deviceData;
    }
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'deviceId': build.androidId,
      'deviceType': "Android",
      'deviceBrand': '${build.brand} ${build.model}',
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'deviceId': data.identifierForVendor,
      'deviceType': "iOS",
      'deviceBrand': data.utsname.machine,
    };
  }
}
