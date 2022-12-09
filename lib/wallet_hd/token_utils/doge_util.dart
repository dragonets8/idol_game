import 'package:flutter_bitcoin/flutter_bitcoin.dart' as BitcoinFlutter;
import 'package:idol_game/wallet_hd/config.dart';

final dogeCoinTestnetNetwork = new BitcoinFlutter.NetworkType(
    messagePrefix: 'Dogecoin Signed Message:\n',
    bip32: new BitcoinFlutter.Bip32Type(
        public: 0x043587cf // xpubkey
        ,
        private: 0x04358394 //xprivkey
        ),
    pubKeyHash: 0x71,
    scriptHash: 0xc4,
    wif: 0xf1 //private key
    );

final dogeCoinMainnetNetwork = new BitcoinFlutter.NetworkType(
    messagePrefix: 'Dogecoin Signed Message:\n',
    bip32:
        new BitcoinFlutter.Bip32Type(public: 0x02facafd, private: 0x02fac398),
    pubKeyHash: 0x1e,
    scriptHash: 0x16,
    wif: 0x9e);

generateDogeAddress(root, {index = 0}) async {
  var coinType = TokenType.doge.toString();
  var node =
      root.derivePath("m/44'/" + coinType + "'/0'/0/" + index.toString());

  String address = new BitcoinFlutter.P2PKH(
          data: new BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: ChainConfig.doge.network)
      .data
      .address;
  print('ticker: Doge --  address: $address');
  return address;
}

String getDogeAddressForNode(node, {String tickerName}) {
  return BitcoinFlutter.P2PKH(
          data: new BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: ChainConfig.doge.network)
      .data
      .address;
}
