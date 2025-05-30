import "dart:async";
import "dart:io";

import "package:android_id/android_id.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:safe_device/safe_device.dart";

class DeviceInfoServiceImpl implements DeviceInfoService {
  DeviceInfoServiceImpl._privateConstructor();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  static DeviceInfoServiceImpl? _instance;
  Completer<void>? _deviceInfoCompleter;

  static DeviceInfoServiceImpl get instance {
    if (_instance == null) {
      _instance = DeviceInfoServiceImpl._privateConstructor();
      unawaited(_instance?._initialise());
    }
    return _instance!;
  }

  @override
  Future<DeviceInfoPlugin> get deviceInfoPlugin async {
    await _deviceInfoCompleter?.future;
    return _deviceInfoPlugin;
  }

  @override
  Future<Map<String, dynamic>> get deviceData async {
    await _deviceInfoCompleter?.future;
    return _deviceData;
  }

  @override
  Future<String> get deviceID async {
    await _deviceInfoCompleter?.future;
    if (Platform.isIOS) {
      return _deviceData["identifierForVendor"];
    } else if (Platform.isAndroid) {
      return _deviceData["androidId"];
    }
    return "";
  }

  @override
  Future<bool> get isDevelopmentModeEnable async {
    await _deviceInfoCompleter?.future;
    return _deviceData["isDevelopmentModeEnable"];
  }

  @override
  Future<bool> get isPhysicalDevice async {
    await _deviceInfoCompleter?.future;
    return _deviceData["isPhysicalDevice"];
  }

  @override
  Future<bool> get isRooted async {
    await _deviceInfoCompleter?.future;
    return _deviceData["app.isRooted"];
  }

  @override
  Future<AddDeviceParams> get addDeviceParams async {
    await _deviceInfoCompleter?.future;
    return AddDeviceParams(
      fcmToken: "",
      manufacturer: Platform.isIOS ? "apple" : _deviceData["manufacturer"],
      deviceModel: _deviceData[Platform.isIOS ? "utsname.machine" : "model"],
      deviceOs: Platform.isIOS ? "ios" : "android",
      deviceOsVersion: Platform.isIOS
          ? _deviceData["systemVersion"]
          : _deviceData["version.release"],
      appVersion: _deviceData["app.version"],
      ramSize: "",
      screenResolution: "",
      isRooted: _deviceData["app.isRooted"],
    );
  }

  Future<void> _initialise() async {
    await _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    //initialize completer
    _deviceInfoCompleter = Completer<void>();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    bool isRooted = await SafeDevice.isJailBroken;
    bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    try {
      if (kIsWeb) {
        deviceData =
            _readWebBrowserInfo(await _deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          final String? androidId = await const AndroidId().getId();
          deviceData = _readAndroidBuildData(
            await _deviceInfoPlugin.androidInfo,
            isRooted,
            await PackageInfo.fromPlatform(),
            androidId,
            isDevelopmentModeEnable,
          );
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(
            await _deviceInfoPlugin.iosInfo,
            isRooted,
            await PackageInfo.fromPlatform(),
            isDevelopmentModeEnable,
          );
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await _deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await _deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData =
              _readWindowsDeviceInfo(await _deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        "Error:": "Failed to get platform version.",
      };
    }

    _deviceData = deviceData;
    _deviceInfoCompleter?.complete();
  }

  Map<String, dynamic> _readAndroidBuildData(
    AndroidDeviceInfo build,
    bool isRooted,
    PackageInfo packageInfo,
    String? androidId,
    bool isDevelopmentModeEnable,
  ) {
    return <String, dynamic>{
      "app.isRooted": isRooted,
      "app.name": packageInfo.appName,
      "app.packageName": packageInfo.packageName,
      "app.version": packageInfo.version,
      "app.buildNumber": packageInfo.buildNumber,
      "version.securityPatch": build.version.securityPatch,
      "version.sdkInt": build.version.sdkInt,
      "version.release": build.version.release,
      "version.previewSdkInt": build.version.previewSdkInt,
      "version.incremental": build.version.incremental,
      "version.codename": build.version.codename,
      "version.baseOS": build.version.baseOS,
      "board": build.board,
      "bootloader": build.bootloader,
      "brand": build.brand,
      "device": build.device,
      "display": build.display,
      "fingerprint": build.fingerprint,
      "hardware": build.hardware,
      "host": build.host,
      "id": build.id,
      "manufacturer": build.manufacturer,
      "model": build.model,
      "product": build.product,
      "supported32BitAbis": build.supported32BitAbis,
      "supported64BitAbis": build.supported64BitAbis,
      "supportedAbis": build.supportedAbis,
      "tags": build.tags,
      "type": build.type,
      "isPhysicalDevice": build.isPhysicalDevice,
      "androidId": androidId,
      "systemFeatures": build.systemFeatures,
      "isDevelopmentModeEnable": isDevelopmentModeEnable,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(
    IosDeviceInfo data,
    bool isRooted,
    PackageInfo packageInfo,
    bool isDevelopmentModeEnable,
  ) {
    return <String, dynamic>{
      "app.isRooted": isRooted,
      "app.name": packageInfo.appName,
      "app.packageName": packageInfo.packageName,
      "app.version": packageInfo.version,
      "app.buildNumber": packageInfo.buildNumber,
      "name": data.name,
      "systemName": data.systemName,
      "systemVersion": data.systemVersion,
      "model": data.model,
      "localizedModel": data.localizedModel,
      "identifierForVendor": data.identifierForVendor,
      "isPhysicalDevice": data.isPhysicalDevice,
      "utsname.sysname": data.utsname.sysname,
      "utsname.nodename": data.utsname.nodename,
      "utsname.release": data.utsname.release,
      "utsname.version": data.utsname.version,
      "utsname.machine": data.utsname.machine,
      "isDevelopmentModeEnable": isDevelopmentModeEnable,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      "name": data.name,
      "version": data.version,
      "id": data.id,
      "idLike": data.idLike,
      "versionCodename": data.versionCodename,
      "versionId": data.versionId,
      "prettyName": data.prettyName,
      "buildId": data.buildId,
      "variant": data.variant,
      "variantId": data.variantId,
      "machineId": data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      "browserName": data.browserName.name,
      "appCodeName": data.appCodeName,
      "appName": data.appName,
      "appVersion": data.appVersion,
      "deviceMemory": data.deviceMemory,
      "language": data.language,
      "languages": data.languages,
      "platform": data.platform,
      "product": data.product,
      "productSub": data.productSub,
      "userAgent": data.userAgent,
      "vendor": data.vendor,
      "vendorSub": data.vendorSub,
      "hardwareConcurrency": data.hardwareConcurrency,
      "maxTouchPoints": data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      "computerName": data.computerName,
      "hostName": data.hostName,
      "arch": data.arch,
      "model": data.model,
      "kernelVersion": data.kernelVersion,
      "osRelease": data.osRelease,
      "activeCPUs": data.activeCPUs,
      "memorySize": data.memorySize,
      "cpuFrequency": data.cpuFrequency,
      "systemGUID": data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      "numberOfCores": data.numberOfCores,
      "computerName": data.computerName,
      "systemMemoryInMegabytes": data.systemMemoryInMegabytes,
    };
  }
}
