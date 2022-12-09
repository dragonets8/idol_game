import 'dart:convert';

SendCodeEntity fromJson(String str) =>
    SendCodeEntity.fromJson(json.decode(str));

String toJson(SendCodeEntity data) => json.encode(data.toJson());

class SendCodeEntity {
  String code;
  String result;

  SendCodeEntity({
    this.code,
    this.result,
  });

  factory SendCodeEntity.fromJson(Map<String, dynamic> json) => SendCodeEntity(
        code: json["code"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "result": result,
      };
}
