import 'package:favicon/favicon.dart' as favicon;

class AccountImageHelper {
  static Future<String> getIcon(String url) async {
    try {
      var icon = await favicon.Favicon.getBest(url);
      return icon.url;
    } catch (err) {
      throw err;
    }
  }
}
