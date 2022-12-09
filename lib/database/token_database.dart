import 'package:idol_game/database/wallet_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TokenDB {
  factory TokenDB() => _shared();
  static TokenDB _instance;

  String dbPath;
  Database database;

  TokenDB._init() {
    getDatabasesPath().then((path) async {
      dbPath = join(path, "token.db");
      database = await openDatabase(dbPath, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Token (id INTEGER PRIMARY KEY, walletId INTEGER, tokenId INTEGER, name TEXT, image TEXT, chain TEXT, chainName TEXT, isDefault INTEGER, isSelect INTEGER, contract TEXT, decimals TEXT, coingecko TEXT, address TEXT, btcPrice REAL, usdPrice REAL, cnyPrice REAL, balance REAL,legalBalance REAL, modify INTEGER, priceTime INTEGER)');
      });
    });
  }

  static TokenDB _shared() {
    if (_instance == null) {
      _instance = TokenDB._init();
    }
    return _instance;
  }

  // 连接数据库
  connectDB() {
    print("数据库已连接");
  }

  // 刷新币种
  refeshToken(Map<String, dynamic> walletMap, Map<String, dynamic> tokenMap,
      {bool isLast = false, Function() complete}) {
    bool isDefault = tokenMap["display"];
    String tokenAddress =
        tokenMap["name"] == "BTC" ? walletMap["btc"] : walletMap["smart"];
    Map<String, dynamic> tokenNew = {
      'walletId': walletMap["id"],
      'tokenId': tokenMap["id"],
      'name': tokenMap["name"],
      'image': tokenMap["image"],
      'chain': tokenMap["chain"],
      'chainName': tokenMap["chainName"],
      'contract': tokenMap["contract"],
      'decimals': tokenMap["decimals"],
      'coingecko': tokenMap["coingecko"],
      'modify': tokenMap["modifyTime"],
      'isDefault': isDefault ? 1 : 0,
      'isSelect': isDefault ? 1 : 0,
      'address': tokenAddress,
      'btcPrice': 0,
      'usdPrice': 0,
      'cnyPrice': 0,
      'balance': 0,
      'legalBalance': 0,
      'priceTime': 0,
    };
    Map<String, dynamic> tokenUpdate = {
      'walletId': walletMap["id"],
      'tokenId': tokenMap["id"],
      'name': tokenMap["name"],
      'image': tokenMap["image"],
      'chain': tokenMap["chain"],
      'chainName': tokenMap["chainName"],
      'contract': tokenMap["contract"],
      'decimals': tokenMap["decimals"],
      'coingecko': tokenMap["coingecko"],
      'modify': tokenMap["modifyTime"],
      'address': tokenAddress,
    };
    database
        .query("Token", where: "walletId = ${walletMap["id"]}")
        .then((queryData) {
      if (queryData.length > 0) {
        if ((queryData.where((element) => element["tokenId"] == tokenMap["id"]))
                .toList()
                .length >
            0) {
          int id = queryData
              .where((element) => element["tokenId"] == tokenMap["id"])
              .toList()
              .first["id"];
          database.update("Token", tokenUpdate, where: "id = $id");
        } else {
          database.insert("Token", tokenNew).then((tokenId) {});
        }
      } else {
        database.insert("Token", tokenNew).then((tokenId) {});
      }
      isLast ? complete() : null;
    });
  }

  // 查询Token
  queryToken(String whereStr, Function(List<Map<String, dynamic>>) queryData) {
    WalletDB().queryWallet("active = 1", (walletData) {
      int walletId = walletData.first["id"];
      database.query("Token", where: whereStr, orderBy: "tokenId").then((maps) {
        queryData(
            maps.where((element) => element["walletId"] == walletId).toList());
      });
    });
  }

  // 修改Token
  updateToken(int tokenId, Map<String, dynamic> tokenMap) {
    database.update("Token", tokenMap, where: "id = $tokenId");
  }
}
