import 'package:flutter_bitcoin/flutter_bitcoin.dart' as BitcoinFlutter;
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/wallet_hd/token_utils/doge_util.dart';

enum ChainType { btc, erc20, bep20, hrc20 }

const bool isPro = true;
const bool isMainnet = true;
const String etherApiKey = "WJ6BB548BUJHQ6KN9V5DIA41QH48UFPNKA";
const String binanceApiKey = "ADC6EZFR2HRW3C5RHFQN85SFNSK6DCAWD5";
const String huobiApiKey = "82MD8ZTJDTWJWK6F2KJHJNYHC7JG4UNY4T";

class DecimalConfig {
  static int valueDecimal = 4;
  static int priceDecimal = 6;
}

class ChainConfig {
  static BtcChain btc = BtcChain(
      network: isMainnet ? BitcoinFlutter.bitcoin : BitcoinFlutter.testnet,
      bytesPerInput: 152,
      satoshisPerBytes: 100);

  static BtcChain doge = BtcChain(
      network: isMainnet ? dogeCoinMainnetNetwork : dogeCoinTestnetNetwork,
      bytesPerInput: 152,
      satoshisPerBytes: 800000);

  static SmartChain erc20 = SmartChain(
      name: "ERC20",
      symbol: "ETH",
      type: ChainType.erc20,
      rpc: isMainnet
          ? "https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
          : "https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
      explorer:
          isMainnet ? "https://etherscan.io" : "https://ropsten.etherscan.io",
      scan: "Etherscan",
      chainId: isMainnet ? 1 : 3,
      gasPrice: isMainnet ? 5 : 12,
      gasPriceMax: 200,
      gasLimit: 21000);

  static SmartChain bep20 = SmartChain(
      name: "BEP20",
      symbol: "BNB",
      type: ChainType.bep20,
      rpc: isMainnet
          ? "https://bsc.node.xwg.games/"
          : "https://bsc-testnet.node.xwg.games/",
      explorer:
          isMainnet ? "https://bscscan.com" : "https://testnet.bscscan.com",
      scan: "BscScan",
      chainId: isMainnet ? 56 : 97,
      gasPrice: isMainnet ? 5 : 12,
      gasPriceMax: 200,
      gasLimit: 21000);

  static SmartChain hrc20 = SmartChain(
      name: "HRC20",
      symbol: "HT",
      type: ChainType.hrc20,
      rpc: isMainnet
          ? "https://http-mainnet.hecochain.com"
          : "https://http-testnet.hecochain.com",
      explorer:
          isMainnet ? "https://hecoinfo.com" : "https://testnet.hecoinfo.com",
      scan: "HecoInfo",
      chainId: isMainnet ? 128 : 256,
      gasPrice: isMainnet ? 5 : 12,
      gasPriceMax: 200,
      gasLimit: 21000);
}

class Endpoints {
  static String btc = isMainnet
      ? 'https://btcprod.fabcoinapi.com/'
      : 'https://btctest.fabcoinapi.com/';
  static String erc20 = isMainnet
      ? 'https://api.etherscan.io/api'
      : 'https://api-ropsten.etherscan.io/api';
  static String bep20 = isMainnet
      ? 'https://api.bscscan.com/api'
      : 'https://api-testnet.bscscan.com/api';
  static String hrc20 = isMainnet
      ? 'https://api.hecoinfo.com/api'
      : "https://api-testnet.hecoinfo.com/api";
}

class Apis {
  static String host = isPro
      ? 'https://walletapi.xwg.games/dapp'
      : 'http://45.112.206.236:9809/dapp';
  static String secret =
      isPro ? 'iTRMlooK1NYph2UFxSe/mQ==' : 'iTRMlooK1NYph2UFxSe/mQ==';
  static String queryVersion = '/xwg/queryVersion';
  static String bindAddress = '/xwg/bindAddress';
  static String queryChains = '/xwg/queryChains';
  static String queryTokens = '/xwg/queryCoins';
  static String getPriceRate = '/xwg/getPriceRate';
  static String queryTranscation = '/xwg/queryTranscation';
  static String queryDappConfs = '/xwg/queryDappConfs';
  static String queryAds = '/xwg/queryAds';

  static String sendCode = '/user/sendCode';
  static String register = "/user/register";
  static String login = "/user/login";
  static String modifyPass = "/user/modifyPass";
  static String bindWallet = "/user/bindWallet";
  static String deleteUser = "/user/cancellation";
}

class GameConfig {
  static DappConf dc1Dapp = DappConf(
      nameCn: "Dream Card 1.0",
      nameEn: "Dream Card 1.0",
      url: isMainnet
          ? "https://www.xwggame.com/"
          : "https://dreamcard.xwgdata.net/",
      chainName: "BEP20",
      introductionCn: "",
      introductionEn: "");

  static DappConf heroDapp = DappConf(
      nameCn: "Hero Card",
      nameEn: "Hero Card",
      url: isMainnet
          ? "https://herocard.xwggames.com/"
          : "https://herocard.xwggames.com/",
      chainName: "BEP20",
      introductionCn: "",
      introductionEn: "");

  static DappConf idolDapp = DappConf(
      nameCn: "Idol",
      nameEn: "Idol",
      url: isMainnet
          ? "https://test.dreamidols.app/loading.html"
          : "https://test2.dreamidols.app/loading.html",
      chainName: "BEP20",
      introductionCn: "",
      introductionEn: "");
}

class ContractConfig {
  static SmartContract eth = SmartContract(
      erc20: isMainnet
          ? "0x1c35eCBc06ae6061d925A2fC2920779a1896282c"
          : "0x1c35eCBc06ae6061d925A2fC2920779a1896282c",
      bep20: isMainnet
          ? "0x2170ed0880ac9a755fd29b2688956bd959f933f8"
          : "0xd66c6b4f0be8ce5b39d52e0fd1344c389929b378",
      hrc20: isMainnet
          ? "0x64ff637fb478863b7468bc97d30a5bf3a428a1fd"
          : "0xfeb76ae65c11b363bd452afb4a7ec59925848656");

  static SmartContract bnb = SmartContract(
      erc20: isMainnet
          ? "0xB8c77482e45F1F44dE1745F52C74426C631bDD52"
          : "0x2cf3fbad1f2f346f4d0dd3b36fc214bb43e55d63",
      bep20: isMainnet
          ? "0xE90e361892d258F28e3a2E758EEB7E571e370c6f"
          : "0xE90e361892d258F28e3a2E758EEB7E571e370c6f",
      hrc20: "");

  static SmartContract usdt = SmartContract(
      erc20: isMainnet
          ? "0xdac17f958d2ee523a2206206994597c13d831ec7"
          : "0x110a13fc3efe6a245b50102d2d79b3e76125ae83",
      bep20: isMainnet
          ? "0x55d398326f99059fF775485246999027B3197955"
          : "0xa4bff8ad707de6a458539d02b0d984d639455364",
      hrc20: isMainnet
          ? "0xa71edc38d189767582c38a3145b5873052c3e47a"
          : "0x04f535663110a392a6504839beed34e019fdb4e0");

  static SmartContract busd = SmartContract(
      erc20: isMainnet ? "" : "",
      bep20: isMainnet
          ? "0xe9e7cea3dedca5984780bafc599bd69add087d56"
          : "0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee",
      hrc20: isMainnet ? "" : "");

  static SmartContract usdc = SmartContract(
      erc20: isMainnet ? "" : "",
      bep20: isMainnet
          ? "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d"
          : "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
      hrc20: isMainnet ? "" : "");

  static SmartContract xwg = SmartContract(
      erc20: isMainnet
          ? "0x6b23c89196deb721e6fd9726e6c76e4810a464bc"
          : "0x6b23c89196deb721e6fd9726e6c76e4810a464bc",
      bep20: isMainnet
          ? "0x6b23c89196deb721e6fd9726e6c76e4810a464bc"
          : "0xc2326ad202409d5f367ebf822f577850b9b84d81",
      hrc20: "");

  static SmartContract dreamcard = SmartContract(
      erc20: "",
      bep20: isMainnet
          ? "0xe6965b4f189dbdb2bd65e60abaeb531b6fe9580b"
          : "0x6c127C9Cf6b4E0F5C6bEcA1156a63ce688669a4C",
      hrc20: "");

  static SmartContract xeqp = SmartContract(
      erc20: "",
      bep20: isMainnet
          ? "0xe15d12D29dfb8a0020a59492886A36CAa90DB724"
          : "0xe15d12D29dfb8a0020a59492886A36CAa90DB724",
      hrc20: "");

  static SmartContract lucid = SmartContract(
      erc20: "",
      bep20: isMainnet
          ? "0x93a1c932f2dEc6A3CA55A8b3eDd5D541958BD156"
          : "0x737ae9571A5c80A6B647a64c103A3164F21ad589",
      hrc20: "");

  static SmartContract link = SmartContract(
      erc20: isMainnet ? "0x514910771af9ca656af840dff83e8264ecf986ca" : "",
      bep20: isMainnet ? "0xf8a0bf9cf54bb92f17374d9e9a321e6a111a51bd" : "",
      hrc20: isMainnet
          ? "0x9e004545c59d359f6b7bfb06a26390b087717b42"
          : "0x3e24e9d2c824b0ac2c82edc931b67252099b8e79");
}

class SmartContract {
  String erc20;
  String bep20;
  String hrc20;

  SmartContract({this.erc20, this.bep20, this.hrc20});
}

class TokenType {
  static int btc = 1;
  static int eth = 60;
  static int bch = 1;
  static int ltc = 1;
  static int doge = 1;
  static int trx = 195;
}

class BtcChain {
  BitcoinFlutter.NetworkType network;
  int bytesPerInput;
  int satoshisPerBytes;

  BtcChain({this.network, this.bytesPerInput, this.satoshisPerBytes});
}

class SmartChain {
  String name;
  String symbol;
  ChainType type;
  String rpc;
  String explorer;
  String scan;
  int chainId;
  int gasPrice;
  int gasPriceMax;
  int gasLimit;

  SmartChain(
      {this.name,
      this.symbol,
      this.type,
      this.rpc,
      this.explorer,
      this.scan,
      this.chainId,
      this.gasPrice,
      this.gasPriceMax,
      this.gasLimit});
}
