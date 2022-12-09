import 'dart:io';

import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/main/widgets/common_webview.dart';
import 'package:idol_game/provider/locale_provider.dart';
import 'package:idol_game/services/dio_manager.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/navigator_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_app_update/update_model.dart';
import 'dart:convert';

class UpdateUtils {
  static checkForUpdate() async {
    String platform = Platform.isIOS ? "ios" : "android";
    DioManager().request<UpdateEntity>(Apis.queryVersion,
        params: {"system": platform}, success: (updateEntity) {
      print(updateEntity.toJson());
      checkNewVersion(updateEntity);
    }, error: (error) {
      print(error.message);
    });
  }

  static checkNewVersion(UpdateEntity updateEntity) {
    AzhonAppUpdate.getVersionName.then((version) {
      if (UpdateUtils.haveNewVersion(updateEntity.version, version)) {
        showUpdateDialog(updateEntity);
      }
    });
  }

  static showUpdateDialog(UpdateEntity updateEntity) {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Colours.bg_dark,
                title: Text(
                    LocaleProvider().localeIndex > 0
                        ? updateEntity.tittleCn
                        : updateEntity.tittleEn,
                    style: TextStyles.naviTitle),
                content: Text(
                    LocaleProvider().localeIndex > 0
                        ? updateEntity.describeCn
                        : updateEntity.describeEn,
                    style: TextStyles.wallet_manage_private),
                actions: <Widget>[
                  updateEntity.forceUpdate
                      ? SizedBox()
                      : TextButton(
                          child: Text(S.of(context).cancel,
                              style: TextStyles.transfer_sheet_assist),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                  TextButton(
                    child: Text(S.of(context).update,
                        style: TextStyles.transfer_sheet_assist),
                    onPressed: () {
                      if (!updateEntity.forceUpdate) {
                        Navigator.of(context).pop();
                      }
                      if (Platform.isIOS) {
                        NavigatorUtils.pushTransparentPage(
                            context,
                            CommonWebView(
                                title: "TestFlight",
                                initialUrl:
                                    "https://testflight.apple.com/join/W5A9qu1a"));
                      } else {
                        downloadUpdate(updateEntity);
                      }
                    },
                  ),
                ],
              ));
        });
  }

  static downloadUpdate(UpdateEntity updateEntity) {
    UpdateModel model = UpdateModel(
      updateEntity.download,
      "flutterUpdate.apk",
      "ic_launcher",
      updateEntity.describeEn,
      iOSUrl: 'https://itunes.apple.com/cn/app/抖音/id1142110895',
      showiOSDialog: false,
    );
    AzhonAppUpdate.update(model).then((value) => print(value));
  }

  static bool haveNewVersion(String newVersion, String old) {
    if (newVersion == null || newVersion.isEmpty || old == null || old.isEmpty)
      return false;
    int newVersionInt, oldVersion;
    var newList = newVersion.split('.');
    var oldList = old.split('.');
    if (newList.length == 0 || oldList.length == 0) {
      return false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        return true;
      } else if (newVersionInt < oldVersion) {
        return false;
      }
    }
    return false;
  }
}

UpdateEntity rainbowbyteFromJson(String str) =>
    UpdateEntity.fromJson(json.decode(str));

String rainbowbyteToJson(UpdateEntity data) => json.encode(data.toJson());

class UpdateEntity {
  UpdateEntity({
    this.id,
    this.createTime,
    this.modifyTime,
    this.system,
    this.version,
    this.isLatest,
    this.forceUpdate,
    this.download,
    this.introduction,
    this.tittleCn,
    this.tittleEn,
    this.describeCn,
    this.describeEn,
  });

  int id;
  int createTime;
  int modifyTime;
  String system;
  String version;
  bool isLatest;
  bool forceUpdate;
  String download;
  String introduction;
  String tittleCn;
  String tittleEn;
  String describeCn;
  String describeEn;

  factory UpdateEntity.fromJson(Map<String, dynamic> json) => UpdateEntity(
        id: json["id"],
        createTime: json["createTime"],
        modifyTime: json["modifyTime"],
        system: json["system"],
        version: json["version"],
        isLatest: json["isLatest"],
        forceUpdate: json["forceUpdate"],
        download: json["download"],
        introduction: json["introduction"],
        tittleCn: json["tittleCn"],
        tittleEn: json["tittleEn"],
        describeCn: json["describeCn"],
        describeEn: json["describeEn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createTime": createTime,
        "modifyTime": modifyTime,
        "system": system,
        "version": version,
        "isLatest": isLatest,
        "forceUpdate": forceUpdate,
        "download": download,
        "introduction": introduction,
        "tittleCn": tittleCn,
        "tittleEn": tittleEn,
        "describeCn": describeCn,
        "describeEn": describeEn,
      };
}
