import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChainDB {
  factory ChainDB() => _shared();
  static ChainDB _instance;

  String dbPath;
  Database database;

  ChainDB._init() {
    getDatabasesPath().then((path) async {
      dbPath = join(path, "chain.db");
      database = await openDatabase(dbPath, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Chain (id INTEGER PRIMARY KEY, status TEXT, name TEXT, type TEXT, image TEXT, rpc TEXT, chainId TEXT, symbol TEXT, blockBrowserUrl TEXT, displayWeight INTEGER)');
      });
    });
  }

  static ChainDB _shared() {
    if (_instance == null) {
      _instance = ChainDB._init();
    }
    return _instance;
  }

  // 连接数据库
  connectDB() {
    print("数据库已连接");
  }

  // 刷新 Chain
  updateChain(Chain chain, {bool isLast = false, Function() complete}) {
    Map<String, dynamic> chainUpdate = {
      'status': chain.status,
      'name': chain.name,
      'type': chain.type,
      'image': chain.image,
      'rpc': chain.rpc,
      'chainId': chain.chainId,
      'symbol': chain.symbol,
      'displayWeight': chain.displayWeight,
      'blockBrowserUrl': chain.blockBrowserUrl,
    };
    database.query("Chain", where: "name = ?", whereArgs: [chain.name]).then(
        (queryData) {
      if (queryData.length > 0) {
        int id = queryData.first["id"];
        database.update("Chain", chainUpdate, where: "id = $id");
      } else {
        database.insert("Chain", chainUpdate).then((chainId) {});
      }
      isLast ? complete() : null;
    });
  }

  // 查询所有 Chain
  queryAllChain(Function(List<Map<String, dynamic>>) queryData) {
    database.query("Chain", where: "id > 0").then((maps) {
      queryData(maps);
    });
  }

  // 查询 Chain
  Future<Chain> queryChain(String chainType) async {
    dynamic queryData = await database.query("Chain",
        where: "type = ?", whereArgs: [chainType], orderBy: "displayWeight");
    return Chain.fromJson(queryData.first);
  }

  // 删除 Chain
  deleteChain() {
    database.delete("Chain", where: "id > 0").then((value) {});
  }
}
