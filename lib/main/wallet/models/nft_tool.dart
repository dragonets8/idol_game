import 'package:idol_game/main/wallet/models/dreamcard_transaction.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:idol_game/abi/nft.g.dart';
import 'dart:convert';

class NFTTool {
  static nftUrl(
      String contract, BigInt nftId, Function(String) balanceHandler) async {
    final client = Web3Client(ChainConfig.bep20.rpc, Client());
    final nftContract =
        NFTContract(address: EthereumAddress.fromHex(contract), client: client);
    nftContract.nftUri(nftId).then((imageUrl) {
      print("image：$imageUrl");
      balanceHandler(imageUrl);
    });
    await client.dispose();
  }

  static nftAmount(
      String address, String contract, Function(BigInt) balanceHandler) async {
    final client = Web3Client(ChainConfig.bep20.rpc, Client());
    final ownerAddress = EthereumAddress.fromHex(address);
    final nftContract =
        NFTContract(address: EthereumAddress.fromHex(contract), client: client);
    nftContract.nftBalance(ownerAddress).then((amount) {
      print("卡牌数量：$amount");
      balanceHandler(amount);
    });
    await client.dispose();
  }

  static nftId(String address, String contract, BigInt nftIndex,
      Function(BigInt) idHandler) async {
    final client = Web3Client(ChainConfig.bep20.rpc, Client());
    final ownerAddress = EthereumAddress.fromHex(address);
    final nftContract =
        NFTContract(address: EthereumAddress.fromHex(contract), client: client);
    nftContract.nftByIndex(ownerAddress, nftIndex).then((cardId) {
      print("卡牌ID：$cardId");
      idHandler(cardId);
    });
    await client.dispose();
  }

  static transfer(String privateKey, String contract, String fAddress,
      String tAddress, String cardId, Function(String) txHandler) async {
    final client = Web3Client(ChainConfig.bep20.rpc, Client());
    final credentials = await client.credentialsFromPrivateKey(privateKey);
    final fromAddress = EthereumAddress.fromHex(fAddress);
    final toAddress = EthereumAddress.fromHex(tAddress);
    final nftContract =
        NFTContract(address: EthereumAddress.fromHex(contract), client: client);
    nftContract
        .transfer(fromAddress, toAddress, BigInt.parse(cardId),
            credentials: credentials)
        .then((tx) {
      print("交易ID：$tx");
      txHandler(tx);
    });
    await client.dispose();
  }

  static nftTransactions(String cardAddress, String contract,
      Function(DreamCardTransactions) transactionHandler) async {
    EasyLoading.show();
    var transactionUrl = "";
    transactionUrl = Endpoints.bep20 +
        "?module=account&action=tokennfttx&contractaddress=$contract&address=$cardAddress&page=1&offset=50&sort=desc&apikey=$binanceApiKey";
    print("请求卡牌记录：$transactionUrl");
    try {
      var response = await get(Uri.parse(transactionUrl));
      DreamCardTransactions transactions =
          DreamCardTransactions.fromJson(jsonDecode(response.body));
      if (transactions.status == "1") {
        transactionHandler(transactions);
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
