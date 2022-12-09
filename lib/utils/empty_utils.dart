import 'package:flutter_easyloading/flutter_easyloading.dart';

class EmptyUtils {
  static bool noEmpty(List<List<dynamic>> objsList) {
    for (var i = 0; i < objsList.length; i++) {
      List<dynamic> objs = objsList[i];
      if (objs[0] == null) {
        EasyLoading.showToast(objs[1] + " is empty");
        return false;
      }
      if (objs[0] is String && objs[0] == "") {
        EasyLoading.showToast(objs[1] + " is empty");
        return false;
      }
      if (objs[0] is int && objs[0] == 0) {
        EasyLoading.showToast(objs[1] + " is empty");
        return false;
      }
      if (objs[0] is double && objs[0] == 0.0) {
        EasyLoading.showToast(objs[1] + " is empty");
        return false;
      }
    }
    return true;
  }

  static String intToString(int intValue) {
    if (intValue == null) {
      return "";
    } else {
      return "$intValue";
    }
  }

  static int boolToIndex(bool isOrNot) {
    if (isOrNot == null) {
      return -1;
    } else {
      return isOrNot ? 0 : 1;
    }
  }

  static List<String> stringToArray(String arrayString) {
    if (arrayString == null) {
      return [];
    } else {
      return arrayString.split("|");
    }
  }
}
