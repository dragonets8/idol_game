import 'package:idol_game/wallet_hd/config.dart';
import 'package:idol_game/wallet_hd/token_utils/string_util.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future getBalance(
    {String token, String chain, String address, String contract = ""}) async {
  var balanceUrl = "";
  if (token == "ETH") {
    balanceUrl = Endpoints.erc20 +
        "?module=account&action=balance&address=$address&apikey=$etherApiKey";
  } else if (token == "BNB") {
    balanceUrl = Endpoints.bep20 +
        "?module=account&action=balance&address=$address&apikey=$binanceApiKey";
  } else {
    if (chain == "ERC20") {
      balanceUrl = Endpoints.erc20 +
          "?module=account&action=tokenbalance&contractaddress=$contract&address=$address&tag=latest&apikey=$etherApiKey";
    }
    if (chain == "BEP20") {
      balanceUrl = Endpoints.bep20 +
          "?module=account&action=tokenbalance&contractaddress=$contract&address=$address&tag=latest&apikey=$binanceApiKey";
    }
  }
  print("请求余额：$balanceUrl");
  var tokenBalance = 0.0;
  try {
    var response = await http.get(Uri.parse(balanceUrl));
    Map<String, dynamic> balance = jsonDecode(response.body);
    tokenBalance = bigNum2Double(
        balance['result'], token == "USDT" && chain == "ERC20" ? 6 : 18);
  } catch (e) {}
  return {'balance': tokenBalance, 'lockbalance': 0.0};
}
