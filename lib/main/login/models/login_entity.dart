import 'dart:convert';

LoginEntity fromJson(String str) => LoginEntity.fromJson(json.decode(str));

String toJson(LoginEntity data) => json.encode(data.toJson());

class LoginEntity {
  int id;
  String walletName;
  String privateKey;
  String btcAddress;
  String smartAddress;

  LoginEntity({
    this.id,
    this.walletName,
    this.privateKey,
    this.btcAddress,
    this.smartAddress,
  });

  factory LoginEntity.fromJson(Map<String, dynamic> json) => LoginEntity(
        id: json["id"],
        walletName: json["walletName"],
        privateKey: json["privateKey"],
        btcAddress: json["btcAddress"],
        smartAddress: json["smartAddress"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "walletName": walletName,
        "privateKey": privateKey,
        "btcAddress": btcAddress,
        "smartAddress": smartAddress,
      };
}
