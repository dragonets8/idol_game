import 'package:idol_game/main/wallet/models/transaction_entity.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:idol_game/wallet_hd/token_utils/string_util.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future getEthBalanceByAddress(String address) async {
  var url = Endpoints.erc20 +
      "?module=account&action=balance&address=$address&apikey=$etherApiKey";
  print("请求EHT余额：$url");
  var ethBalance = 0.0;
  try {
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> balance = jsonDecode(response.body);
    ethBalance = bigNum2Double(balance['result']);
  } catch (e) {}
  return {'balance': ethBalance, 'lockbalance': 0.0};
}

Future getEthTransactions({String address}) async {
  var url = Endpoints.erc20 +
      "?module=account&action=txlist&address=$address&page=1&offset=50&sort=desc&apikey=$etherApiKey";
  print("请求ETH交易记录：$url");
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
