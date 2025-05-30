import "package:device_info_plus/device_info_plus.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";

abstract class DeviceInfoService {
  Future<String> get deviceID;
  Future<DeviceInfoPlugin> get deviceInfoPlugin;
  Future<Map<String, dynamic>> get deviceData;
  Future<AddDeviceParams> get addDeviceParams;
  Future<bool> get isRooted;
  Future<bool> get isPhysicalDevice;
  Future<bool> get isDevelopmentModeEnable;
}
