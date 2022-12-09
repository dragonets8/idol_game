import 'package:idol_game/main/dapp/models/ads_entity.dart';
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/main/login/models/login_entity.dart';
import 'package:idol_game/main/login/models/send_code_entity.dart';
import 'package:idol_game/main/wallet/models/chain_entity.dart';
import 'package:idol_game/main/wallet/models/token_entity.dart';
import 'package:idol_game/main/wallet/models/transaction_entity.dart';
import 'package:idol_game/services/response_entity.dart';
import 'package:idol_game/utils/update_utils.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (json == null) {
      return null;
    } else if (T.toString() == "UpdateEntity") {
      return UpdateEntity.fromJson(json) as T;
    } else if (T.toString() == "ChainEntity") {
      return ChainEntity.fromJson(json) as T;
    } else if (T.toString() == "TokenEntityList") {
      return TokenEntityList.fromJson(json) as T;
    } else if (T.toString() == "TransactionEntity") {
      return TransactionEntity.fromJson(json) as T;
    } else if (T.toString() == "AdsEntity") {
      return AdsEntity.fromJson(json) as T;
    } else if (T.toString() == "DappEntity") {
      return DappEntity.fromJson(json) as T;
    } else if (T.toString() == "SendCodeEntity") {
      return SendCodeEntity.fromJson(json) as T;
    } else if (T.toString() == "LoginEntity") {
      return LoginEntity.fromJson(json) as T;
    } else {
      return json as T;
    }
  }

  static ResponseHeaders generateAppHeaders(json) {
    if (json == null) {
      return null;
    } else {
      return ResponseHeaders.fromJson(json);
    }
  }
}
