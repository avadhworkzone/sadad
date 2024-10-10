import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> getStoragePermission() async {
  PermissionStatus permissionStatus = await Permission.storage.status;
  if (permissionStatus != PermissionStatus.granted) {
    permissionStatus = await Permission.storage.request();
    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus = await Permission.storage.request();
      if (permissionStatus != PermissionStatus.granted) {
        permissionStatus = await Permission.storage.request();
      }
    }
  }
  if (permissionStatus == PermissionStatus.granted) {
    return true;
  }
  AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
  if (androidDeviceInfo.version.sdkInt >= 33) {
    return true;
  }

  return false;
}
