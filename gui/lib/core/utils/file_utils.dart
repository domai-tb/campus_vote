import 'dart:io';

Future<void> changeAllFilePermissions(
  String dirPath,
  String permissions,
) async {
  for (final file in Directory(dirPath).listSync(recursive: true)) {
    final type = FileSystemEntity.typeSync(file.path);
    if (type == FileSystemEntityType.file) {
      changeFilePermissions(file.path, permissions);
    }
  }
}

void changeFilePermissions(String filePath, String permissions) {
  try {
    if (Platform.isLinux || Platform.isMacOS) {
      Process.runSync('chmod', [permissions, filePath]);
    } else if (Platform.isWindows) {
      // For Windows, convert Linux-like permissions to ACLs
      final String aclPermissions = _convertLinuxToWindowsPermissions(permissions);
      Process.runSync('icacls', [filePath, '/grant', aclPermissions]);
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  } catch (e) {
    throw Exception('failed to change file permissions: $e');
  }
}

String _convertLinuxToWindowsPermissions(String permissions) {
  final Map<String, String> permissionMap = {
    '7': 'F', // Full control
    '6': 'M', // Modify
    '5': 'RX', // Read and execute
    '4': 'R', // Read-only
    '3': 'WX', // Write and execute
    '2': 'W', // Write-only
    '1': 'X', // Execute-only
    '0': '', // No permissions
  };

  // Extract owner, group, and others permissions
  final String ownerPerm = permissions[0];
  final String groupPerm = permissions[1];
  final String othersPerm = permissions[2];

  // Convert to Windows ACL format
  final String ownerAcl = permissionMap[ownerPerm] ?? '';
  final String groupAcl = permissionMap[groupPerm] ?? '';
  final String othersAcl = permissionMap[othersPerm] ?? '';

  // Construct ACL string for Windows
  final List<String> aclParts = [];
  if (ownerAcl.isNotEmpty) aclParts.add('Everyone:($ownerAcl)');
  if (groupAcl.isNotEmpty) aclParts.add('Everyone:($groupAcl)');
  if (othersAcl.isNotEmpty) aclParts.add('Everyone:($othersAcl)');

  return aclParts.join(' ');
}
