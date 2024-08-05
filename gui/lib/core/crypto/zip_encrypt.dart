import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:archive/archive_io.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Zips and encrypts sub-directories of [inputDirPath] and writes the encrypted zips to [outputDirPath].
Future<void> zipAndEncryptDirectories(
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

  // Iterate through each sub-directory
  await for (final subDir in inputDir.list()) {
    if (subDir is Directory) {
      // Zip the sub-directory
      final zipFilePath = path.join(outputDir.path, '${path.basename(subDir.path)}.zip');
      await zipDirectory(subDir, zipFilePath);

      // Encrypt the zip file
      final encryptedFilePath = '$zipFilePath.enc';
      await encryptFile(zipFilePath, encryptedFilePath, key);

      // Remove the original zip file
      await File(zipFilePath).delete();
    }
  }
}

/// Zips the directory at [sourceDir] into a zip file at [zipFilePath].
Future<void> zipDirectory(Directory sourceDir, String zipFilePath) async {
  final encoder = ZipFileEncoder();
  encoder.create(zipFilePath);
  await encoder.addDirectory(sourceDir);
  await encoder.close();
}

/// Encrypts the file at [inputFilePath] and writes the encrypted data to [outputFilePath].
Future<void> encryptFile(
  String inputFilePath,
  String outputFilePath,
  encrypt.Key key,
) async {
  final inputFile = File(inputFilePath);
  final encryptedFile = File(outputFilePath);

  // Read the input file
  final inputData = await inputFile.readAsBytes();

  // Encrypt the data
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.gcm),
  );
  final encryptedData = encrypter.encryptBytes(inputData, iv: iv);

  // Combine IV and encrypted data
  final combinedData = Uint8List(iv.bytes.length + encryptedData.bytes.length)
    ..setRange(0, iv.bytes.length, iv.bytes)
    ..setRange(
      iv.bytes.length,
      iv.bytes.length + encryptedData.bytes.length,
      encryptedData.bytes,
    );

  // Write the combined data
  await encryptedFile.writeAsBytes(combinedData);
}
