import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DappDB {
  factory DappDB() => _shared();
  static DappDB _instance;

  String dbPath;
  Database database;
  Map<String, SmartChain> chainMap = {
    "ERC20": ChainConfig.erc20,
    "BEP20": ChainConfig.bep20,
    "HRC20": ChainConfig.hrc20
  };

  DappDB._init() {
    getDatabasesPath().then((path) async {
      dbPath = join(path, "dapp.db");
      database = await openDatabase(dbPath, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Dapp (id INTEGER PRIMARY KEY, nameCn TEXT, nameEn TEXT, recommendType TEXT, displayWeight INTEGER, url TEXT, tag TEXT, chainName TEXT, image TEXT, status TEXT, introductionCn TEXT, introductionEn TEXT)');
      });
    });
  }

  static DappDB _shared() {
    if (_instance == null) {
      _instance = DappDB._init();
    }
    return _instance;
  }

  // 连接数据库
  connectDB() {
    print("数据库已连接");
  }

  // 新增 Dapp
  addDappWith(DappConf dapp, Function(int) successBlock) {
    SmartChain dappChain = smartChainMap[dapp.chainName];
    Map<String, dynamic> dappRow = {
      "nameCn": dapp.nameCn,
      "nameEn": dapp.nameEn,
      "recommendType": dapp.recommendType,
      "displayWeight": dapp.displayWeight,
      "chainName": dapp.chainName,
      "url": dapp.url,
      "tag": dapp.tag,
      "image": dapp.image,
      "status": dapp.status,
      "introductionCn": dapp.introductionCn,
      "introductionEn": dapp.introductionEn,
    };
    database.insert("Dapp", dappRow).then((dappId) {
      successBlock(dappId);
      print("${dapp.nameEn} 添加收藏");
    });
  }

  // 删除 Dapp
  deleteDapp(String dappName, Function() deleteSuccess) {
    database.delete("Dapp", where: "nameEn = ?", whereArgs: [dappName]).then(
        (value) {
      deleteSuccess();
      print("$dappName 移出收藏");
    });
  }

  // 查询是否收藏
  queryFavorite(String dappName, Function(bool) successBlock) {
    database.query("Dapp", where: "nameEn = ?", whereArgs: [dappName]).then(
        (queryDapps) {
      successBlock(queryDapps.length > 0);
    });
  }

  // 查询所有 Dapp
  queryAllDapp(Function(List<DappConf>) successBlock) {
    List<DappConf> dapps = [];
    database.query("Dapp", where: "id > 0", orderBy: "id").then((queryDapps) {
      for (Map<String, dynamic> dappMap in queryDapps.reversed) {
        DappConf dapp = DappConf(
          nameCn: dappMap["nameCn"],
          nameEn: dappMap["nameEn"],
          recommendType: dappMap["recommendType"],
          displayWeight: dappMap["displayWeight"],
          chainName: dappMap["chainName"],
          url: dappMap["url"],
          tag: dappMap["tag"],
          image: dappMap["image"],
          status: dappMap["status"],
          introductionCn: dappMap["introductionCn"],
          introductionEn: dappMap["introductionEn"],
        );
        dapps.add(dapp);
      }
      successBlock(dapps);
    });
  }
}
