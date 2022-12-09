import 'dart:convert';

import 'package:idol_game/wallet_hd/config.dart';

DappEntity rainbowbyteFromJson(String str) =>
    DappEntity.fromJson(json.decode(str));

String rainbowbyteToJson(DappEntity data) => json.encode(data.toJson());

class DappEntity {
  DappEntity({
    this.dappConfs,
  });

  Map<String, List<DappConf>> dappConfs;

  factory DappEntity.fromJson(Map<String, dynamic> json) => DappEntity(
        dappConfs: Map.from(json["dappConfs"]).map((k, v) =>
            MapEntry<String, List<DappConf>>(
                k, List<DappConf>.from(v.map((x) => DappConf.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "dappConfs": Map.from(dappConfs).map((k, v) =>
            MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class DappConf {
  DappConf({
    this.id,
    this.createTime,
    this.modifyTime,
    this.nameCn,
    this.nameEn,
    this.recommendType,
    this.displayWeight,
    this.url,
    this.tag,
    this.chainName,
    this.image,
    this.status,
    this.introductionCn,
    this.introductionEn,
  });

  int id;
  int createTime;
  int modifyTime;
  String nameCn;
  String nameEn;
  String recommendType;
  int displayWeight;
  String url;
  String tag;
  String chainName;
  String image;
  String status;
  String introductionCn;
  String introductionEn;

  factory DappConf.fromJson(Map<String, dynamic> json) => DappConf(
        id: json["id"],
        createTime: json["createTime"],
        modifyTime: json["modifyTime"],
        nameCn: json["nameCn"],
        nameEn: json["nameEn"],
        recommendType: json["recommendType"],
        displayWeight: json["displayWeight"],
        url: json["url"],
        tag: json["tag"],
        chainName: json["chainName"],
        image: json["image"],
        status: json["status"],
        introductionCn: json["introductionCn"],
        introductionEn: json["introductionEn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createTime": createTime,
        "modifyTime": modifyTime,
        "nameCn": nameCn,
        "nameEn": nameEn,
        "recommendType": recommendType,
        "displayWeight": displayWeight,
        "url": url,
        "tag": tag,
        "chainName": chainName,
        "image": image,
        "status": status,
        "introductionCn": introductionCn,
        "introductionEn": introductionEn,
      };
}

Map<String, SmartChain> smartChainMap = {
  "ETH": ChainConfig.erc20,
  "BSC": ChainConfig.bep20,
  "HECO": ChainConfig.hrc20
};

Map<String, String> dappTagMapEn = {
  "1": "Exchanges",
  "2": "DeFi",
  "3": "Marketplaces",
  "4": "Games",
  "5": "Gambling",
  "6": "Social",
  "7": "Collectibles"
};

Map<String, String> dappTagMapCn = {
  "1": "兑换",
  "2": "金融",
  "3": "交易所",
  "4": "游戏",
  "5": "冒险",
  "6": "社交",
  "7": "收藏品"
};
