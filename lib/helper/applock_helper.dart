import 'package:shared_preferences/shared_preferences.dart';

class AppLockHelper {
  static final first = 'first';
  static final second = 'second';
  static final third = 'third';
  static final fourth = 'fourth';

  static bool _isLockActivate = true;

  static getPascodeState() {
    return _isLockActivate;
  }

  static Future<bool> hasPasscode() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      int first = prefs.getInt(AppLockHelper.first);
      _isLockActivate = first != null;
      return _isLockActivate;
    } catch (e) {
      return false;
    }
  }

  static Future<List<int>> getPasscode() async {
    try {
      List<int> passcode = [];
      var prefs = await SharedPreferences.getInstance();
      passcode.add(prefs.getInt(AppLockHelper.first));
      passcode.add(prefs.getInt(AppLockHelper.second));
      passcode.add(prefs.getInt(AppLockHelper.third));
      passcode.add(prefs.getInt(AppLockHelper.fourth));
      return passcode;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setPasscode(List<int> passcode) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppLockHelper.first, passcode[0]);
      await prefs.setInt(AppLockHelper.second, passcode[1]);
      await prefs.setInt(AppLockHelper.third, passcode[2]);
      await prefs.setInt(AppLockHelper.fourth, passcode[3]);
      AppLockHelper._isLockActivate = true;
    } catch (e) {
      AppLockHelper._isLockActivate = false;
    }
  }

  static Future<void> deletePasscode() async {
    await AppLockHelper.setPasscode([null, null, null, null]);
    _isLockActivate = false;
  }
}
