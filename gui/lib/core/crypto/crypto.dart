import 'package:campus_vote/core/crypto/crypto_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:campus_vote/core/crypto/decrypt_unzip.dart' as dec;
import 'package:campus_vote/core/crypto/zip_encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart' as encrypt;

class Crypto {
  final FlutterSecureStorage storage;

  Crypto({required this.storage});

  /// Reads the encryption key from [FlutterSecureStorage] or generates a new one.
  /// If a new key is generated, it will be stored within [FlutterSecureStorage].
  Future<encrypt.Key> getExportEncKey({bool overwriteKey = false}) async {
    final String? storedKey = await storage.read(key: EXPORT_ENCKEY_KEY);

    encrypt.Key encKey;
    if (storedKey == null || overwriteKey) {
      encKey = encrypt.Key.fromLength(32);
      await storage.write(key: EXPORT_ENCKEY_KEY, value: encKey.base64);
    } else {
      try {
        encKey = encrypt.Key.fromBase64(storedKey);
      } catch (_) {
        throw Exception('encryption password is not valid base64 encoded');
      }
    }

    return encKey;
  }

  /// Stores an key in keyring that is used to decrypt config files.
  Future<void> storeExportEncKey(String base64Key) async {
    await storage.write(key: EXPORT_ENCKEY_KEY, value: base64Key);
  }

  /// Zips and encrypts sub-directories of [inputDirPath] and writes the
  /// encrypted zips to [outputDirPath].
  Future<void> zipAndEncryptDirectories(
    String inputDirPath,
    String outputDirPath,
  ) async {
    final encKey = await getExportEncKey();
    return enc.zipAndEncryptDirectories(inputDirPath, outputDirPath, encKey);
  }

  /// Decrypts and unzips encrypted zip files in [inputDirPath] and writes the
  /// unzipped directories to [outputDirPath].
  Future<String> decryptAndUnzipFile(
    String inputDirPath,
    String outputDirPath,
  ) async {
    final encKey = await getExportEncKey();
    return dec.decryptAndUnzipFile(inputDirPath, outputDirPath, encKey);
  }

  /// Encrypts the file at [inputFilePath] and writes the encrypted data to [outputFilePath].
  Future<void> encryptFile(
    String inputFilePath,
    String outputFilePath,
  ) async {
    final encKey = await getExportEncKey();
    await enc.encryptFile(inputFilePath, outputFilePath, encKey);
  }

  /// Decrypts the file at [inputFilePath] and writes the decrypted data to [outputFilePath].
  Future<void> decryptFile(
    String inputFilePath,
    String outputFilePath,
  ) async {
    final encKey = await getExportEncKey();
    await dec.decryptFile(inputFilePath, outputFilePath, encKey);
  }
}
