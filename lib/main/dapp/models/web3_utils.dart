import 'dart:convert';
import 'dart:typed_data';
import 'package:idol_game/main/dapp/models/dapp_transaction.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:http/http.dart';

import 'package:idol_game/wallet_hd/token_utils/string_util.dart';
import 'package:web3dart/web3dart.dart';

class Web3Utils {
  static signPersonalMessage(String signMessage, String privateKey,
      SmartChain smartChain, Function(String) signatureHandler) async {
    Uint8List signData = ascii.encode(signMessage);
    final client = Web3Client("", Client());
    final credentials = await client.credentialsFromPrivateKey(privateKey);
    credentials.signPersonalMessage(signData).then((signature) {
      signatureHandler("0x" + uint8ListToHex(signature));
    });
  }

  static getEstimateGas(DappTransaction transaction, SmartChain smartChain,
      Function(BigInt) gasHandler) async {
    BigInt value = BigInt.parse(transaction.value ?? "0");
    Uint8List data = hexToBytes(transaction.data.replaceFirst("0x", ""));
    final client = Web3Client(smartChain.rpc, Client());
    client
        .estimateGas(
      sender: EthereumAddress.fromHex(transaction.from),
      to: EthereumAddress.fromHex(transaction.to),
      value: EtherAmount.fromUnitAndValue(EtherUnit.wei, value),
      amountOfGas: value,
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5),
      data: data,
    )
        .then((estimateGas) {
      gasHandler(estimateGas);
    });
  }

  static signTransaction(DappTransaction transaction, String privateKey,
      SmartChain smartChain, Function(String) txHandler) async {
    BigInt gas = BigInt.parse(transaction.gas ?? "0");
    BigInt value = BigInt.parse(transaction.value ?? "0");
    Uint8List data = hexToBytes(transaction.data.replaceFirst("0x", ""));
    final client = Web3Client(smartChain.rpc, Client());
    final credentials = await client.credentialsFromPrivateKey(privateKey);
    client
        .sendTransaction(
      credentials,
      Transaction(
          from: EthereumAddress.fromHex(transaction.from),
          to: EthereumAddress.fromHex(transaction.to),
          gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5),
          maxGas: gas.toInt(),
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, value),
          data: data),
      chainId: smartChain.chainId,
    )
        .then((txid) {
      print("Txid: $txid");
      txHandler(txid);
    });
    await client.dispose();
  }
}
