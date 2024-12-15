import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceId() async {
  String? deviceId;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    //check the device and get the id
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = deviceInfo.id;
    }
    //when the assign id is less than 4 digits/characters
    if (deviceId != null && deviceId.length < 4) {
      if (Platform.isIOS) {
        deviceId += "_android_";
      } else if (Platform.isAndroid) {
        deviceId += "__ios__";
      }
    }
    //when device id is null
    if (Platform.isIOS) {
      deviceId = "flutter_ios_device_id";
    } else if (Platform.isAndroid) {
      deviceId = "flutter_android_device_id";
    }
    //encode the device id and convert to only digit format
    final userId = md5
        .convert(utf8.encode(deviceId!))
        .toString()
        .replaceAll(RegExp(r'[^0-9]'), '');

    //return last 6 digit as uinqe id
    return userId.substring(userId.length - 6);
  } catch (err) {
    throw Exception(err);
  }
}
