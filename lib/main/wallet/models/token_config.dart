import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/wallet_hd/config.dart';

List<TokenEntity> tokenConfig = [
  TokenEntity(
      id: 5,
      name: "XWG",
      image: "http://45.112.206.236:9810/icon/token/xwg.png",
      chain: "BEP20",
      chainName: "BSC",
      display: true,
      contract: ContractConfig.xwg.bep20,
      decimals: "18",
      coingecko: "x-world-games"),
  TokenEntity(
      id: 4,
      name: "BNB",
      image: "http://45.112.206.236:9810/icon/token/bnb.png",
      chain: "BEP20",
      chainName: "BSC",
      display: true,
      contract: "",
      decimals: "18",
      coingecko: "binancecoin"),
  TokenEntity(
      id: 9,
      name: "BUSD",
      image: "http://45.112.206.236:9810/icon/token/busd.png",
      chain: "BEP20",
      chainName: "BSC",
      display: true,
      contract: ContractConfig.busd.bep20,
      decimals: "18",
      coingecko: "binance-usd")
];
