import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:idol_game/services/dio_tools.dart';
import 'package:idol_game/utils/encrypt_utils.dart';
import 'package:idol_game/wallet_hd/config.dart';
import 'response_entity.dart';
import 'error_entity.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:path_provider/path_provider.dart';

class DioManager {
  static final DioManager _shared = DioManager._internal();
  factory DioManager() => _shared;

  Dio dio;
  DioManager._internal() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
          baseUrl: Apis.host,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          receiveDataWhenStatusError: true,
          connectTimeout: 30000,
          receiveTimeout: 15000,
          headers: {"Accept": "application/json", "Accept-Language": "zh-CN"});
      dio = Dio(options);
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          // ignore: missing_return
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };
    }
  }

  Future request<T>(String path,
      {Map<String, dynamic> params,
      Function(T) success,
      Function(ErrorEntity) error}) async {
    EasyLoading.show();
    getApplicationDocumentsDirectory().then((Directory appDocDir) async {
      var cookieJar =
          PersistCookieJar(storage: FileStorage(appDocDir.path + "/.cookies/"));
      dio.interceptors.add(CookieManager(cookieJar));
      print("Path：\n $path \nParama：\n $params");
      try {
        Map<String, dynamic> finalParams =
            params.length > 0 ? DioTools.bodyWithParama(params) : {};
        Response response = await dio.post(path, data: finalParams);
        if (response != null) {
          Map<String, dynamic> responseJson;
          if (response.data is Map<String, dynamic>) {
            responseJson = response.data;
          } else {
            String responseString =
                EncryptUtils.aesDecrypt(Apis.secret, response.data.toString());
            responseJson = jsonDecode(responseString);
          }
          ResponseEntity entity = ResponseEntity<T>.fromJson(responseJson);
          if (entity.header.tranStatus == "200" ||
              entity.header.tranStatus == "true") {
            success(entity.body);
          } else {
            EasyLoading.showToast(entity.header.errorMessage);
            error(ErrorEntity(
                code: int.parse(entity.header.errorCode),
                message: entity.header.errorMessage));
          }
        } else {
          error(ErrorEntity(code: -1, message: "Unknown Error"));
          EasyLoading.showToast("Unknown Error");
        }
      } on DioError catch (e) {
        error(createErrorEntity(e));
        EasyLoading.showToast(createErrorEntity(e).message);
      } finally {
        EasyLoading.dismiss();
      }
    });
  }

  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return ErrorEntity(code: -1, message: "Request Cancel");
        }
        break;
      case DioErrorType.connectTimeout:
        {
          return ErrorEntity(code: -1, message: "Connect Timeout");
        }
        break;
      case DioErrorType.receiveTimeout:
        {
          return ErrorEntity(code: -1, message: "Receive Timeout");
        }
        break;
      case DioErrorType.sendTimeout:
        {
          return ErrorEntity(code: -1, message: "Send Timeout");
        }
        break;
      case DioErrorType.response:
        {
          try {
            int errCode = error.response.statusCode;
            String errMessage = error.response.statusMessage;
            return ErrorEntity(code: errCode, message: errMessage);
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "Unknown Error");
          }
        }
        break;
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }
}
