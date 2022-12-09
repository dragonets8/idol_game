// To parse this JSON data, do
//
//     final rainbowbyte = rainbowbyteFromJson(jsonString);

import 'dart:convert';

TransactionEntity rainbowbyteFromJson(String str) =>
    TransactionEntity.fromJson(json.decode(str));

String rainbowbyteToJson(TransactionEntity data) => json.encode(data.toJson());

class TransactionEntity {
  TransactionEntity({
    this.status,
    this.message,
    this.result,
  });

  String status;
  String message;
  List<Transaction> result;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      TransactionEntity(
        status: json["status"],
        message: json["message"],
        result: List<Transaction>.from(
            json["result"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    this.blockNumber,
    this.timeStamp,
    this.hash,
    this.nonce,
    this.blockHash,
    this.transactionIndex,
    this.from,
    this.to,
    this.value,
    this.gas,
    this.gasPrice,
    this.tokenName,
    this.tokenSymbol,
    this.tokenDecimal,
    this.isError,
    this.txreceiptStatus,
    this.input,
    this.contractAddress,
    this.cumulativeGasUsed,
    this.gasUsed,
    this.confirmations,
  });

  String blockNumber;
  int timeStamp;
  String hash;
  String nonce;
  String blockHash;
  String transactionIndex;
  String from;
  String to;
  String value;
  String gas;
  String gasPrice;
  String tokenName;
  String tokenSymbol;
  String tokenDecimal;
  String isError;
  String txreceiptStatus;
  String input;
  String contractAddress;
  String cumulativeGasUsed;
  String gasUsed;
  String confirmations;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        blockNumber: json["blockNumber"],
        timeStamp: json["timeStamp"],
        hash: json["hash"],
        nonce: json["nonce"],
        blockHash: json["blockHash"],
        transactionIndex: json["transactionIndex"],
        from: json["from"],
        to: json["to"],
        value: json["value"],
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        tokenName: json["tokenName"],
        tokenSymbol: json["tokenSymbol"],
        tokenDecimal: json["tokenDecimal"],
        isError: json["isError"],
        txreceiptStatus: json["txreceipt_status"],
        input: json["input"],
        contractAddress: json["contractAddress"],
        cumulativeGasUsed: json["cumulativeGasUsed"],
        gasUsed: json["gasUsed"],
        confirmations: json["confirmations"],
      );

  Map<String, dynamic> toJson() => {
        "blockNumber": blockNumber,
        "timeStamp": timeStamp,
        "hash": hash,
        "nonce": nonce,
        "blockHash": blockHash,
        "transactionIndex": transactionIndex,
        "from": from,
        "to": to,
        "value": value,
        "gas": gas,
        "gasPrice": gasPrice,
        "tokenName": tokenName,
        "tokenSymbol": tokenSymbol,
        "tokenDecimal": tokenDecimal,
        "isError": isError,
        "txreceipt_status": txreceiptStatus,
        "input": input,
        "contractAddress": contractAddress,
        "cumulativeGasUsed": cumulativeGasUsed,
        "gasUsed": gasUsed,
        "confirmations": confirmations,
      };
}
