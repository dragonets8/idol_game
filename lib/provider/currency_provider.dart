import 'package:flutter/material.dart';
import 'package:idol_game/services/storage_service.dart';

class CurrencyProvider extends ChangeNotifier {
  ///配置语言语种
  static const currencyValueList = ['usd', 'cny'];

  ///本地语言选择的 key值
  static const kCurrencyIndex = 'kCurrencyIndex';

  int _currencyIndex;

  int get currencyIndex => _currencyIndex;

  String get currency {
    return currencyValueList[currencyIndex];
  }

  CurrencyProvider() {
    _currencyIndex = StorageService.shared.getInt(kCurrencyIndex) ?? 0;
  }
  switchCurrency(int index) {
    _currencyIndex = index;
    notifyListeners();

    StorageService.shared.setInt(kCurrencyIndex, index);
  }

  static String currencyName(index, context) {
    switch (index) {
      case 0:
        return 'USD';
      case 1:
        return 'CNY';
      default:
        return '';
    }
  }
}
