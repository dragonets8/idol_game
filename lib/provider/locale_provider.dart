import 'package:flutter/material.dart';
import 'package:idol_game/services/storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  ///配置语言语种
  static const localeValueList = ['en', 'zh-CN'];

  ///本地语言选择的 key值
  static const kLocaleIndex = 'kLocaleIndex';

  int _localeIndex;

  int get localeIndex => _localeIndex;

  Locale get locale {
    var value = localeValueList[_localeIndex].split("-");
    return Locale(value[0], value.length == 2 ? value[1] : '');
  }

  LocaleProvider() {
    _localeIndex = StorageService.shared.getInt(kLocaleIndex) ?? 0;
  }
  switchLocale(int index) {
    _localeIndex = index;
    notifyListeners();

    StorageService.shared.setInt(kLocaleIndex, index);
  }

  static String localeName(index, context) {
    switch (index) {
      case 0:
        return 'English';
      case 1:
        return '中文';
      default:
        return '';
    }
  }
}
