import 'dart:convert';
import 'package:idol_game/utils/encrypt_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';

class DioTools {
  static Map<String, dynamic> getParamas(
      Map<String, dynamic> paramas, String loginToken) {
    Map<String, dynamic> headers = {
      "appChannel": "doctor",
      "appVersion": "1.0.0",
      "deviceBrand": "iPhone",
      "deviceId": "3241454",
      "deviceType": "iOS",
      "loginToken": loginToken,
      "nonce": "3241234",
      "requestNo": "34321",
      "requestToken": "4154143",
      "sign": "1342314",
      "timestamp": "1606449556000",
      "version": "string"
    };
    return {"header": headers, "body": paramas};
  }

  static Map<String, dynamic> bodyWithParama(Map<String, dynamic> params) {
    String paramaString = jsonEncode(params);
    String encryptParams = EncryptUtils.aesEncrypt(Apis.secret, paramaString);
    print(encryptParams);
    return {"body": encryptParams};
  }
}
