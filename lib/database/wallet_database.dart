import 'package:idol_game/database/wallet_entity.dart';
import 'package:idol_game/utils/encrypt_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WalletDB {
  factory WalletDB() => _shared();
  static WalletDB _instance;

  String dbPath;
  Database database;

  WalletDB._init() {
    getDatabasesPath().then((path) async {
      dbPath = join(path, "wallet.db");
      database = await openDatabase(dbPath, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Wallet (id INTEGER PRIMARY KEY, name TEXT, private TEXT, btc TEXT, smart TEXT, type INTEGER, active INTEGER, time INTEGER)');
      });
    });
  }

  static WalletDB _shared() {
    if (_instance == null) {
      _instance = WalletDB._init();
    }
    return _instance;
  }

  // 连接数据库
  connectDB() {
    print("数据库已连接");
  }

  // 新增钱包
  addWalletWith(
      WalletEntity wallet, String keyStore, Function(int) successBlock) {
    print(keyStore);
    print(wallet.private);
    Map<String, dynamic> walletRow = {
      'name': wallet.name,
      'private': EncryptUtils.aesEncrypt(keyStore, wallet.private),
      'btc': wallet.btc,
      'smart': wallet.smart,
      'type': wallet.type,
      'active': wallet.active,
      'time': wallet.time,
    };
    print(walletRow);
    database.insert("Wallet", walletRow).then((walletId) {
      activeWallet(walletId);
      successBlock(walletId);
    });
  }

  // 更新私钥
  updateWalletWith(int walletId, String private) {
    database.update("Wallet", {"private": private}, where: "id = $walletId");
  }

  // 查询钱包
  queryWallet(String whereStr, Function(List<Map<String, dynamic>>) queryData) {
    database
        .query("Wallet", where: whereStr, orderBy: "id")
        .then((maps) => {queryData(maps)});
  }

  // 根据钱包地址查询
  queryWalletWithAddress(
      String walletAddress, Function(List<Map<String, dynamic>>) queryData) {
    database
        .query("Wallet",
            where: "smart = ?", whereArgs: [walletAddress], orderBy: "id")
        .then((maps) => {queryData(maps)});
  }

  // 根据钱包类型查询
  queryWalletWithType(
      int type, Function(List<Map<String, dynamic>>) queryData) {
    database
        .query("Wallet", where: "type = ?", whereArgs: [type], orderBy: "id")
        .then((maps) => {queryData(maps)});
  }

  // 查询当前激活钱包
  queryWalletActivity(Function(List<Map<String, dynamic>>) queryData) {
    database
        .query("Wallet", where: "active = ?", whereArgs: [1], orderBy: "id")
        .then((maps) => {queryData(maps)});
  }

  // 删除钱包
  deleteWallet(int walletId, Function() deleteSuccess) {
    database.delete("Wallet", where: "id = $walletId").then((value) {
      deleteSuccess();
      print("$walletId已删除");
    });
  }

  // 激活钱包
  activeWallet(int walletId) {
    database.update("Wallet", {"active": 1}, where: "id = $walletId");
    database.update("Wallet", {"active": 0}, where: "id != $walletId");
  }

  // 重命名钱包
  renameWallet(int walletId, String walletName) {
    database.update("Wallet", {"name": walletName}, where: "id = $walletId");
  }
}
