// To parse this JSON data, do
//
//     final DreamCardTransactions = DreamCardTransactionsFromJson(jsonString);

import 'dart:convert';

DreamCardTransactions fromJson(String str) =>
    DreamCardTransactions.fromJson(json.decode(str));

String toJson(DreamCardTransactions data) => json.encode(data.toJson());

class DreamCardTransactions {
  DreamCardTransactions({
    this.status,
    this.message,
    this.result,
  });

  String status;
  String message;
  List<DreamCardTransaction> result;

  factory DreamCardTransactions.fromJson(Map<String, dynamic> json) =>
      DreamCardTransactions(
        status: json["status"],
        message: json["message"],
        result: List<DreamCardTransaction>.from(
            json["result"].map((x) => DreamCardTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class DreamCardTransaction {
  DreamCardTransaction({
    this.blockNumber,
    this.timeStamp,
    this.hash,
    this.nonce,
    this.blockHash,
    this.from,
    this.contractAddress,
    this.to,
    this.tokenId,
    this.tokenName,
    this.tokenSymbol,
    this.tokenDecimal,
    this.transactionIndex,
    this.gas,
    this.gasPrice,
    this.gasUsed,
    this.cumulativeGasUsed,
    this.input,
    this.confirmations,
  });

  String blockNumber;
  String timeStamp;
  String hash;
  String nonce;
  String blockHash;
  String from;
  String contractAddress;
  String to;
  String tokenId;
  String tokenName;
  String tokenSymbol;
  String tokenDecimal;
  String transactionIndex;
  String gas;
  String gasPrice;
  String gasUsed;
  String cumulativeGasUsed;
  String input;
  String confirmations;

  factory DreamCardTransaction.fromJson(Map<String, dynamic> json) =>
      DreamCardTransaction(
        blockNumber: json["blockNumber"],
        timeStamp: json["timeStamp"],
        hash: json["hash"],
        nonce: json["nonce"],
        blockHash: json["blockHash"],
        from: json["from"],
        contractAddress: json["contractAddress"],
        to: json["to"],
        tokenId: json["tokenID"],
        tokenName: json["tokenName"],
        tokenSymbol: json["tokenSymbol"],
        tokenDecimal: json["tokenDecimal"],
        transactionIndex: json["transactionIndex"],
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        gasUsed: json["gasUsed"],
        cumulativeGasUsed: json["cumulativeGasUsed"],
        input: json["input"],
        confirmations: json["confirmations"],
      );

  Map<String, dynamic> toJson() => {
        "blockNumber": blockNumber,
        "timeStamp": timeStamp,
        "hash": hash,
        "nonce": nonce,
        "blockHash": blockHash,
        "from": from,
        "contractAddress": contractAddress,
        "to": to,
        "tokenID": tokenId,
        "tokenName": tokenName,
        "tokenSymbol": tokenSymbol,
        "tokenDecimal": tokenDecimal,
        "transactionIndex": transactionIndex,
        "gas": gas,
        "gasPrice": gasPrice,
        "gasUsed": gasUsed,
        "cumulativeGasUsed": cumulativeGasUsed,
        "input": input,
        "confirmations": confirmations,
      };
}
