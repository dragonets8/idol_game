class ValidUtils {
  static bool isEthAddress(String address) {
    RegExp addressReg = new RegExp(r"^0x[0-9a-fA-F]{40}$");
    return addressReg.hasMatch(address);
  }

  static bool isPrivateKey(String private) {
    String no0xAddress1 = private.replaceFirst("0x", "");
    String no0xAddress2 = no0xAddress1.replaceFirst("0X", "");
    RegExp privateReg = new RegExp(r"^[0-9a-fA-F]{64}$");
    return privateReg.hasMatch(no0xAddress2);
  }

  static bool isPassword(String password) {
    RegExp regExpStr =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,20}$');
    bool isPassword = regExpStr.hasMatch(password);
    return isPassword;
  }
}
