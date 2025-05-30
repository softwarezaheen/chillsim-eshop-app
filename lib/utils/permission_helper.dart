import "dart:io";

import "package:permission_handler/permission_handler.dart";

class PermissionHelper {
  static List<Permission> androidPermissions = <Permission>[
    // 在这里添加需要的权限
    Permission.photos,
  ];

  static List<Permission> iosPermissions = <Permission>[
    // 在这里添加需要的权限
    Permission.storage,
  ];

  static Future<Map<Permission, PermissionStatus>>
      requestStoragePermission() async {
    if (Platform.isIOS) {
      return iosPermissions.request();
    }
    return androidPermissions.request();
  }

  static Future<Map<Permission, PermissionStatus>> request(
    Permission permission,
  ) async {
    final List<Permission> permissions = <Permission>[permission];
    return permissions.request();
  }

  static bool isDenied(Map<Permission, PermissionStatus> result) {
    bool isDenied = false;
    result.forEach((Permission key, PermissionStatus value) {
      if (value == PermissionStatus.denied) {
        isDenied = true;
        return;
      }
    });
    return isDenied;
  }

  static Future<bool> checkGranted(Permission permission) async {
    PermissionStatus storageStatus = await permission.status;
    if (storageStatus == PermissionStatus.granted) {
      //已授权
      return true;
    } else {
      //拒绝授权
      return false;
    }
  }
}
