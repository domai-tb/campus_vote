// lib/utils/decrypt_unzip.dart

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:archive/archive_io.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Decrypts and unzips encrypted zip files in [inputDirPath] and writes the unzipped directories to [outputDirPath].
Future<void> decryptAndUnzipDirectories(
  String inputDirPath,
  String outputDirPath,
  encrypt.Key key,
) async {
  final inputDir = Directory(inputDirPath);
  final outputDir = Directory(outputDirPath);

  // Ensure the output directory exists
  // ignore: avoid_slow_async_io
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  // Iterate through each encrypted zip file
  await for (final file in inputDir.list()) {
    if (file is File && path.extension(file.path) == '.enc') {
      final zipFilePath =
          path.join(outputDir.path, path.basenameWithoutExtension(file.path));
      final decryptedFilePath = '$zipFilePath.zip';

      // Decrypt the file
      await decryptFile(file.path, decryptedFilePath, key);

      // Unzip the decrypted file
      await unzipFile(decryptedFilePath, zipFilePath);

      // Remove the decrypted zip file
      await File(decryptedFilePath).delete();
    }
  }
}

/// Decrypt and unzip encrypted zip file in [inputFilePath] and writes the unzipped files to [outputDirPath].
Future<void> decryptAndUnzipFile(
  String inputFilePath,
  String outputDirPath,
  encrypt.Key key,
) async {
  final inputFile = File(inputFilePath);
  final outputDir = Directory(outputDirPath);

  // Ensure the output directory exists
  // ignore: avoid_slow_async_io
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  final zipFilePath = path.join(
    outputDir.path,
    path.basenameWithoutExtension(inputFile.path),
  );

  // Decrypt the file
  await decryptFile(inputFile.path, zipFilePath, key);

  // Unzip the decrypted file
  await unzipFile(zipFilePath, outputDir.path);

  // Remove the decrypted zip file
  await File(zipFilePath).delete();
}

/// Decrypts the file at [inputFilePath] and writes the decrypted data to [outputFilePath].
Future<void> decryptFile(
  String inputFilePath,
  String outputFilePath,
  encrypt.Key key,
) async {
  final inputFile = File(inputFilePath);
  final decryptedFile = File(outputFilePath);

  // Read the input file
  final combinedData = await inputFile.readAsBytes();

  // Extract the IV
  final iv = encrypt.IV(combinedData.sublist(0, 16));

  // Extract the encrypted data
  final encryptedData = combinedData.sublist(16);

  // Decrypt the data
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final decryptedData =
      encrypter.decryptBytes(encrypt.Encrypted(encryptedData), iv: iv);

  // Write the decrypted data
  await decryptedFile.writeAsBytes(decryptedData);
}

/// Unzips the zip file at [zipFilePath] to the directory at [outputDirPath].
Future<void> unzipFile(String zipFilePath, String outputDirPath) async {
  final zipFile = File(zipFilePath);
  final bytes = await zipFile.readAsBytes();
  final archive = ZipDecoder().decodeBytes(bytes);

  for (final file in archive) {
    // filename <dir>/<file>
    final filename = path.join(outputDirPath, file.name);
    if (file.isFile) {
      final data = file.content as List<int>;
      File(filename)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      await Directory(filename).create(recursive: true);
    }
  }
}
