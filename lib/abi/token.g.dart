import 'package:web3dart/web3dart.dart';
import 'package:idol_game/abi/abi.dart';

class TokenContract extends GeneratedContract {
  TokenContract({EthereumAddress address, Web3Client client, int chainId})
      : super(
            DeployedContract(ContractAbi.fromJson(Abi.token, 'Token'), address),
            client,
            chainId);

  Future<String> aprovalAddress(EthereumAddress contract, BigInt amount,
      {Credentials credentials}) async {
    final function = self.function('approve');
    final params = [contract, amount];
    final transaction = Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<BigInt> getBalance(EthereumAddress addr) async {
    final function = self.function('balanceOf');
    final params = [addr];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<String> transfer(EthereumAddress addr, BigInt amount,
      {Credentials credentials}) async {
    final function = self.function('transfer');
    final params = [addr, amount];
    final transaction = Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }
}
