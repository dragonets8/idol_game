import 'dart:convert';

DappTransaction fromJson(String str) =>
    DappTransaction.fromJson(json.decode(str));

String toJson(DappTransaction data) => json.encode(data.toJson());

class DappTransaction {
  DappTransaction({
    this.gas,
    this.gasPrice,
    this.value,
    this.from,
    this.to,
    this.data,
  });

  String gas;
  String gasPrice;
  String value;
  String from;
  String to;
  String data;

  factory DappTransaction.fromJson(Map<String, dynamic> json) =>
      DappTransaction(
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        value: json["value"],
        from: json["from"],
        to: json["to"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "gas": gas,
        "gasPrice": gasPrice,
        "value": value,
        "from": from,
        "to": to,
        "data": data,
      };
}
