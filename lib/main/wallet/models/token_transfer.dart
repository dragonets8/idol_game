import 'package:idol_game/abi/token.g.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

// 转账ETH
Future<String> transferEth(double value,
    {String private, String toAddress}) async {
  final client = Web3Client(ChainConfig.erc20.rpc, Client());
  final credentials = await client.credentialsFromPrivateKey(private);
  String tx = await client.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(toAddress),
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, ChainConfig.erc20.gasPrice),
        maxGas: ChainConfig.erc20.gasLimit,
        value: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, BigInt.from(value * 1000000000)),
      ),
      chainId: ChainConfig.erc20.chainId);
  await client.dispose();
  return tx;
}

// 转账ERC20
Future<String> transferErc20(double value,
    {String private, String toAddress, String contract}) async {
  final client = Web3Client(ChainConfig.erc20.rpc, Client());
  final credentials = await client.credentialsFromPrivateKey(private);
  final tokenContract =
      TokenContract(address: EthereumAddress.fromHex(contract), client: client);
  String tx = await tokenContract.transfer(
      EthereumAddress.fromHex(toAddress), BigInt.from((value * 1000000)),
      credentials: credentials);
  await client.dispose();
  return tx;
}

// 转账BNB
Future<String> transferBnb(double value,
    {String private, String toAddress}) async {
  final client = Web3Client(ChainConfig.bep20.rpc, Client());
  final credentials = await client.credentialsFromPrivateKey(private);
  String tx = await client.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(toAddress),
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, ChainConfig.bep20.gasPrice),
        maxGas: ChainConfig.bep20.gasLimit,
        value: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, BigInt.from(value * 1000000000)),
      ),
      chainId: ChainConfig.bep20.chainId);
  await client.dispose();
  return tx;
}

// 转账BEP20
Future<String> transferBep20(double value,
    {String private, String toAddress, String contract}) async {
  final client = Web3Client(ChainConfig.bep20.rpc, Client());
  final credentials = await client.credentialsFromPrivateKey(private);
  final tokenContract =
      TokenContract(address: EthereumAddress.fromHex(contract), client: client);
  String tx = await tokenContract.transfer(EthereumAddress.fromHex(toAddress),
      BigInt.from((value * 1000000000000000000)),
      credentials: credentials);
  await client.dispose();
  return tx;
}

// 转账HT
Future<String> transferHt(double value,
    {String private, String toAddress}) async {
  final client = Web3Client(ChainConfig.hrc20.rpc, Client());
  final credentials = await client.credentialsFromPrivateKey(private);
  String tx = await client.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(toAddress),
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, ChainConfig.hrc20.gasPrice),
        maxGas: ChainConfig.hrc20.gasLimit,
        value: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, BigInt.from(value * 1000000000)),
      ),
      chainId: ChainConfig.hrc20.chainId);
  await client.dispose();
  return tx;
}

// 转账HRC20
Future<String> transferHrc20(double value,
    {String private, String toAddress, String contract}) async {
  final client = Web3Client(ChainConfig.hrc20.rpc, Client());
  final credentials = await client.credentialsFromPrivateKey(private);
  final tokenContract =
      TokenContract(address: EthereumAddress.fromHex(contract), client: client);
  String tx = await tokenContract.transfer(EthereumAddress.fromHex(toAddress),
      BigInt.from((value * 1000000000000000000)),
      credentials: credentials);
  await client.dispose();
  return tx;
}
