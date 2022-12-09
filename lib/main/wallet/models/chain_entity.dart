// To parse this JSON data, do
//
//     final rainbowbyte = rainbowbyteFromJson(jsonString);

import 'dart:convert';

ChainEntity rainbowbyteFromJson(String str) =>
    ChainEntity.fromJson(json.decode(str));

String rainbowbyteToJson(ChainEntity data) => json.encode(data.toJson());

class ChainEntity {
  ChainEntity({
    this.chains,
  });

  List<Chain> chains;

  factory ChainEntity.fromJson(Map<String, dynamic> json) => ChainEntity(
        chains: List<Chain>.from(json["chains"].map((x) => Chain.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chains": List<dynamic>.from(chains.map((x) => x.toJson())),
      };
}

class Chain {
  Chain({
    this.id,
    this.createTime,
    this.modifyTime,
    this.status,
    this.name,
    this.type,
    this.image,
    this.rpc,
    this.chainId,
    this.symbol,
    this.blockBrowserUrl,
    this.displayWeight,
  });

  int id;
  int createTime;
  int modifyTime;
  String status;
  String name;
  String type;
  String image;
  String rpc;
  String chainId;
  String symbol;
  String blockBrowserUrl;
  int displayWeight;

  factory Chain.fromJson(Map<String, dynamic> json) => Chain(
        id: json["id"],
        createTime: json["createTime"],
        modifyTime: json["modifyTime"],
        status: json["status"],
        name: json["name"],
        type: json["type"],
        image: json["image"],
        rpc: json["rpc"],
        chainId: json["chainId"],
        symbol: json["symbol"],
        blockBrowserUrl: json["blockBrowserUrl"],
        displayWeight: json["displayWeight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createTime": createTime,
        "modifyTime": modifyTime,
        "status": status,
        "name": name,
        "type": type,
        "image": image,
        "rpc": rpc,
        "chainId": chainId,
        "symbol": symbol,
        "blockBrowserUrl": blockBrowserUrl,
        "displayWeight": displayWeight,
      };
}
