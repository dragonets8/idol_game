import 'dart:typed_data';
import 'package:crypto/crypto.dart' as CryptoPack;
import 'package:conduit_password_hash/conduit_password_hash.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:idol_game/wallet_hd/token_utils/string_util.dart';

class EncryptUtils {
  static String stringToKey(String original) {
    var gen = PBKDF2(hashAlgorithm: CryptoPack.sha1);
    Uint8List keyStore =
        gen.generateKey(original, "x_wallet", original.length * 6, 16);
    return uint8ListToHex(keyStore);
  }

  //AES加密
  static aesEncrypt(String keyStore, String plainText) {
    final key = Key.fromUtf8(keyStore);
    final iv = IV.fromUtf8(keyStore.substring(1, 9));
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print("AesEncrypt: ${encrypted.base64}");
    return encrypted.base64;
  }

  //AES解密
  static String aesDecrypt(String keyStore, String encrypted) {
    final key = Key.fromUtf8(keyStore);
    final iv = IV.fromUtf8(keyStore.substring(1, 9));
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    try {
      final decrypted = encrypter.decrypt64(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      return "";
    }
  }
}
