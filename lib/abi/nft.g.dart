import 'package:web3dart/web3dart.dart';
import 'package:idol_game/abi/abi.dart';

class NFTContract extends GeneratedContract {
  NFTContract({EthereumAddress address, Web3Client client, int chainId})
      : super(DeployedContract(ContractAbi.fromJson(Abi.nft, 'Token'), address),
            client, chainId);

  Future<String> aprovalAddress(EthereumAddress contract, bool approved,
      {Credentials credentials}) async {
    final function = self.function('setApprovalForAll');
    final params = [contract, approved];
    final transaction = Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<BigInt> nftBalance(EthereumAddress addr) async {
    final function = self.function('balanceOf');
    final params = [addr];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<BigInt> nftByIndex(EthereumAddress addr, BigInt index) async {
    final function = self.function('tokenOfOwnerByIndex');
    final params = [addr, index];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<String> nftUri(BigInt index) async {
    final function = self.function('tokenURI');
    final params = [index];
    final response = await read(function, params);
    return response[0];
  }

  Future<String> transfer(
      EthereumAddress fromAddress, EthereumAddress toAddress, BigInt cardId,
      {Credentials credentials}) async {
    final function = self.function('transferFrom');
    final params = [fromAddress, toAddress, cardId];
    final transaction = Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }
}
