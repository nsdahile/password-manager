import 'package:flutter/foundation.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/encription_exception.dart';

class EncryptionHelper {
  static String _key;
  static final String _keyName = 'encryption-key';

  static Future<String> getKey() async {
    await EncryptionHelper.setKey();
    return EncryptionHelper._key;
  }

  static Future<void> setKey() async {
    if (EncryptionHelper._key != null && EncryptionHelper._key.isNotEmpty)
      return;
    final pref = await SharedPreferences.getInstance();
    EncryptionHelper._key = pref.getString(EncryptionHelper._keyName);
    if (EncryptionHelper._key == null || EncryptionHelper._key.isEmpty) {
      EncryptionHelper._key = await genrateKey();
      await pref.setString(EncryptionHelper._keyName, EncryptionHelper._key);
    }
  }

  static Future<String> genrateKey() async {
    final cryptor = new PlatformStringCryptor();
    final String key = await cryptor.generateRandomKey();
    return key;
  }

  static Future<String> encript(String str) async {
    await EncryptionHelper.setKey();
    final cryptor = new PlatformStringCryptor();
    final String encrypted = await cryptor.encrypt(str, EncryptionHelper._key);
    return encrypted;
  }

  static Future<String> decrypt({@required String str, String key}) async {
    await EncryptionHelper.setKey();
    final cryptor = new PlatformStringCryptor();
    try {
      final String decrypted =
          await cryptor.decrypt(str, key ?? EncryptionHelper._key);
      return decrypted;
    } on MacMismatchException {
      // unable to decrypt (wrong key or forged data)
      throw EncriptionException('Unable to decript, Please enter correct key');
    } catch (err) {
      throw EncriptionException('Unable to decript, Please enter correct key');
    }
  }
}
