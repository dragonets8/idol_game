import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol_game/database/wallet_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/widgets/auth_sheet.dart';
import 'package:flutter/material.dart';
import 'package:idol_game/utils/encrypt_utils.dart';
import 'package:idol_game/utils/valid_utils.dart';

class SecurityUtils {
  static bool verified = false;
  static String inputPassword = "";
  static String newPassword = "";
  static String rePassword = "";
  static String currentPassword = "";

  static showAuth(BuildContext context,
      {bool alwaysNeed = true,
      int walletId = -1,
      Function(String) unlockHandler}) {
    if (verified && !alwaysNeed) {
      passwordForPrivate(context, walletId, currentPassword, (passed, private) {
        if (passed) {
          unlockHandler(private);
        } else {
          EasyLoading.showToast(S.of(context).verify_password_failed);
        }
      });
      return;
    }
    WalletDB().queryWalletActivity((queryData) {
      bool isLoginAuth = queryData.first["type"] == 0;
      AuthSheet.verify(context, isLoginAuth, inputHandler: (input) {
        inputPassword = input;
      }, completeHandler: () {
        passwordForPrivate(context, walletId, inputPassword, (passed, private) {
          if (passed) {
            Navigator.of(context).pop();
            verified = true;
            currentPassword = inputPassword;
            inputPassword = "";
            unlockHandler(private);
          } else {
            EasyLoading.showToast(S.of(context).verify_password_failed);
          }
        });
      });
    });
  }

  static setAuth(BuildContext context,
      {String oldPrivate = "", Function() setHandler}) {
    AuthSheet.set(context, newPassHandler: (input) {
      newPassword = input;
    }, rePassHandler: (input) {
      rePassword = input;
    }, completeHandler: () {
      if (!ValidUtils.isPassword(newPassword)) {
        EasyLoading.showToast(S.of(context).password_format_tips);
      } else if (newPassword != rePassword) {
        EasyLoading.showToast(S.of(context).inconsistent_password);
      } else {
        verified = false;
        currentPassword = newPassword;
        print(currentPassword);
        if (oldPrivate != "") {
          print(oldPrivate);
          String newKeyStore = EncryptUtils.stringToKey(currentPassword);
          print(currentPassword);
          WalletDB().queryWalletWithType(1, (walletData) async {
            for (var wallet in walletData) {
              WalletDB().updateWalletWith(wallet["id"],
                  EncryptUtils.aesEncrypt(newKeyStore, oldPrivate));
            }
          });
        }
        newPassword = "";
        rePassword = "";
        setHandler();
        Navigator.of(context).pop();
      }
    });
  }

  static passwordForPrivate(BuildContext context, int walletId, String password,
      Function(bool, String) passHandler) {
    if (password.length > 0) {
      if (walletId < 0) {
        WalletDB().queryWallet("active = 1", (walletData) async {
          String keyStore = EncryptUtils.stringToKey(password);
          String decrypted =
              EncryptUtils.aesDecrypt(keyStore, walletData.first["private"]);
          passHandler(decrypted != "", decrypted);
        });
      } else {
        WalletDB().queryWallet("id = $walletId", (walletData) async {
          String keyStore = EncryptUtils.stringToKey(password);
          String decrypted =
              EncryptUtils.aesDecrypt(keyStore, walletData.first["private"]);
          passHandler(decrypted != "", decrypted);
        });
      }
    } else {
      EasyLoading.showToast(S.of(context).enter_password_tips);
    }
  }
}
