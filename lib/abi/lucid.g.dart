import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';
import 'package:idol_game/abi/abi.dart';

class LucidContract extends GeneratedContract {
  LucidContract({EthereumAddress address, Web3Client client, int chainId})
      : super(
            DeployedContract(ContractAbi.fromJson(Abi.lucid, 'Token'), address),
            client,
            chainId);

  Future<String> aprovalAddress(EthereumAddress contract, bool approved,
      {Credentials credentials}) async {
    final function = self.function('setApprovalForAll');
    final params = [contract, approved];
    final transaction = Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<BigInt> lucidBalance(EthereumAddress addr, BigInt lucidId) async {
    final function = self.function('balanceOf');
    final params = [addr, lucidId];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<List<dynamic>> allLucidBalance(
      EthereumAddress addr, List<BigInt> lucidIds) async {
    final function = self.function('balanceOfBatch');
    final params = [
      [addr, addr, addr],
      lucidIds
    ];
    final response = await read(function, params);
    return (response[0] as List<dynamic>);
  }

  Future<BigInt> lucidByIndex(EthereumAddress addr, BigInt index) async {
    final function = self.function('tokenOfOwnerByIndex');
    final params = [addr, index];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<String> lucidUri(BigInt index) async {
    final function = self.function('tokenURI');
    final params = [index];
    final response = await read(function, params);
    return response[0];
  }

  Future<String> transfer(EthereumAddress fromAddress,
      EthereumAddress toAddress, BigInt lucidId, BigInt lucidAmount,
      {Credentials credentials}) async {
    final function = self.function('safeTransferFrom');
    final lucidData = Uint8List.fromList([]);
    final params = [fromAddress, toAddress, lucidId, lucidAmount, lucidData];
    final transaction = Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }
}
