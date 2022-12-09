// To parse this JSON data, do
//
//     final rainbowbyte = rainbowbyteFromJson(jsonString);

import 'dart:convert';

import 'package:idol_game/widgets/banner_carousel/banner_model.dart';

AdsEntity rainbowbyteFromJson(String str) =>
    AdsEntity.fromJson(json.decode(str));

String rainbowbyteToJson(AdsEntity data) => json.encode(data.toJson());

class AdsEntity {
  AdsEntity({
    this.ads,
  });

  List<Ad> ads;

  factory AdsEntity.fromJson(Map<String, dynamic> json) => AdsEntity(
        ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
      };
}

class Ad {
  Ad({
    this.id,
    this.createTime,
    this.modifyTime,
    this.name,
    this.imageCn,
    this.imageEn,
    this.linkCn,
    this.linkEn,
    this.displayWeight,
    this.status,
  });

  int id;
  int createTime;
  int modifyTime;
  String name;
  String imageCn;
  String imageEn;
  String linkCn;
  String linkEn;
  int displayWeight;
  String status;

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"],
        createTime: json["createTime"],
        modifyTime: json["modifyTime"],
        name: json["name"],
        imageCn: json["imageCn"],
        imageEn: json["imageEn"],
        linkCn: json["linkCn"],
        linkEn: json["linkEn"],
        displayWeight: json["displayWeight"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createTime": createTime,
        "modifyTime": modifyTime,
        "name": name,
        "imageCn": imageCn,
        "imageEn": imageEn,
        "linkCn": linkCn,
        "linkEn": linkEn,
        "displayWeight": displayWeight,
        "status": status,
      };
}

class BannerImages {
  static const String banner1 =
      "https://hk-zb-public.oss-accelerate.aliyuncs.com/dir/1ff52b56-05ee-48f3-baa8-224a6611dc0e.png";
  static const String banner2 =
      "https://hk-zb-public.oss-accelerate.aliyuncs.com/dir/3c38f221-16fa-4ff9-a020-b70a46385527.png";
  static const String banner3 =
      "https://hk-zb-public.oss-accelerate.aliyuncs.com/dir/a758888e-7f43-4593-9864-678780b3faaf.png";
  static const String banner4 =
      "https://hk-zb-public.oss-accelerate.aliyuncs.com/dir/235836f1-a6d1-4dcd-a6e4-9d1f61a505d1.png";

  static List<BannerModel> listBanner = [
    BannerModel(imagePath: banner1, id: "1"),
    BannerModel(imagePath: banner2, id: "2"),
    BannerModel(imagePath: banner3, id: "3"),
    BannerModel(imagePath: banner4, id: "4"),
  ];
}
