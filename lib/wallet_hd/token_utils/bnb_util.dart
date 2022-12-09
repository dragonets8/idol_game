import 'package:idol_game/main/wallet/models/transaction_entity.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:idol_game/wallet_hd/token_utils/string_util.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future getBnbBalance({String address}) async {
  var url = Endpoints.bep20 +
      "?module=account&action=balance&address=$address&apikey=$binanceApiKey";
  print("请求BNB余额：$url");
  var bnbBalance = 0.0;
  try {
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> balance = jsonDecode(response.body);
    bnbBalance = bigNum2Double(balance['result']);
  } catch (e) {}
  return {'balance': bnbBalance, 'lockbalance': 0.0};
}

Future getBscBalance({String contract, String address}) async {
  var url = Endpoints.bep20 +
      "?module=account&action=tokenbalance&contractaddress=$contract&address=$address&tag=latest&apikey=$binanceApiKey";
  print("请求XWG余额：$url");
  var bscBalance = 0.0;
  try {
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> balance = jsonDecode(response.body);
    bscBalance = bigNum2Double(balance['result']);
  } catch (e) {}
  return {'balance': bscBalance, 'lockbalance': 0.0};
}

Future getBnbTransactions({String address}) async {
  var url = Apis.host + Apis.queryTranscation;
  Map<String, dynamic> parama = {
    "module": "account",
    "action": "txlist",
    "address": address,
    "apikey": "",
    "chain": "bep20",
    "contractaddress": "",
    "offset": "10",
    "page": "1",
    "sort": "desc",
    "envProd": isMainnet
  };
  print("请求BNB交易记录：$url");
  TransactionEntity transactionEntity = TransactionEntity();
  try {
    var response = await http.post(Uri.parse(url), body: parama);
    TransactionEntity entity = TransactionEntity.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
    if (entity.status == "1") {
      transactionEntity = entity;
    }
  } catch (e) {}
  return transactionEntity;
}

Future getBscTransactions({String contract, String address}) async {
  var url = Endpoints.bep20 +
      "?module=account&action=tokentx&contractaddress=$contract&address=$address&page=1&offset=50&sort=desc&apikey=$binanceApiKey";
  print("请求BSC交易记录：$url");
  TransactionEntity transactionEntity = TransactionEntity();
  try {
    var response = await http.get(Uri.parse(url));
    TransactionEntity entity =
        TransactionEntity.fromJson(jsonDecode(response.body));
    if (entity.status == "1") {
      transactionEntity = entity;
    }
  } catch (e) {}
  return transactionEntity;
}
