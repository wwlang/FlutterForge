import 'package:flutter/material.dart';

/// Platform type for a device.
enum DevicePlatform {
  /// iOS devices (iPhone, iPad)
  iOS,

  /// Android devices (Pixel, Samsung, etc.)
  android,

  /// Desktop devices (MacBook, Windows laptops, etc.)
  desktop,
}

/// Specifications for a device frame.
@immutable
class DeviceSpec {
  /// Creates a new device specification.
  const DeviceSpec({
    required this.name,
    required this.width,
    required this.height,
    required this.pixelRatio,
    required this.platform,
    this.safeAreaTop = 0,
    this.safeAreaBottom = 0,
    this.safeAreaLeft = 0,
    this.safeAreaRight = 0,
    this.cornerRadius = 0,
  });

  /// Display name for this device.
  final String name;

  /// Logical width in points.
  final double width;

  /// Logical height in points.
  final double height;

  /// Device pixel ratio.
  final double pixelRatio;

  /// Device platform type.
  final DevicePlatform platform;

  /// Safe area inset from top.
  final double safeAreaTop;

  /// Safe area inset from bottom.
  final double safeAreaBottom;

  /// Safe area inset from left (used in landscape).
  final double safeAreaLeft;

  /// Safe area inset from right (used in landscape).
  final double safeAreaRight;

  /// Corner radius for the device frame.
  final double cornerRadius;

  /// Returns the size of this device in portrait orientation.
  Size get size => Size(width, height);

  /// Returns the size of this device in landscape orientation.
  Size get landscapeSize => Size(height, width);

  /// Returns the safe area insets for portrait orientation.
  EdgeInsets get safeAreaInsets => EdgeInsets.only(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        left: safeAreaLeft,
        right: safeAreaRight,
      );

  /// Returns the safe area insets for landscape orientation.
  /// In landscape, top/bottom become left/right.
  EdgeInsets get landscapeSafeAreaInsets => EdgeInsets.only(
        left: safeAreaTop,
        right: safeAreaBottom,
        top: safeAreaLeft,
        bottom: safeAreaRight,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceSpec && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

/// Pre-defined device specifications based on common devices.
class DeviceSpecs {
  DeviceSpecs._();

  // iOS Devices

  /// iPhone 15 Pro specifications.
  static const iPhone15Pro = DeviceSpec(
    name: 'iPhone 15 Pro',
    width: 393,
    height: 852,
    pixelRatio: 3,
    platform: DevicePlatform.iOS,
    safeAreaTop: 59,
    safeAreaBottom: 34,
    cornerRadius: 55,
  );

  /// iPhone 15 specifications.
  static const iPhone15 = DeviceSpec(
    name: 'iPhone 15',
    width: 390,
    height: 844,
    pixelRatio: 3,
    platform: DevicePlatform.iOS,
    safeAreaTop: 47,
    safeAreaBottom: 34,
    cornerRadius: 47,
  );

  /// iPhone SE specifications.
  static const iPhoneSE = DeviceSpec(
    name: 'iPhone SE',
    width: 375,
    height: 667,
    pixelRatio: 2,
    platform: DevicePlatform.iOS,
    safeAreaTop: 20,
  );

  /// iPad Pro 12.9" specifications.
  static const iPadPro129 = DeviceSpec(
    name: 'iPad Pro 12.9',
    width: 1024,
    height: 1366,
    pixelRatio: 2,
    platform: DevicePlatform.iOS,
    safeAreaTop: 24,
    safeAreaBottom: 20,
    cornerRadius: 18,
  );

  /// iPad mini specifications.
  static const iPadMini = DeviceSpec(
    name: 'iPad mini',
    width: 744,
    height: 1133,
    pixelRatio: 2,
    platform: DevicePlatform.iOS,
    safeAreaTop: 24,
    safeAreaBottom: 20,
    cornerRadius: 18,
  );

  // Android Devices

  /// Google Pixel 8 specifications.
  static const pixel8 = DeviceSpec(
    name: 'Pixel 8',
    width: 412,
    height: 915,
    pixelRatio: 2.75,
    platform: DevicePlatform.android,
    safeAreaTop: 36,
    safeAreaBottom: 48,
    cornerRadius: 40,
  );

  /// Google Pixel 8 Pro specifications.
  static const pixel8Pro = DeviceSpec(
    name: 'Pixel 8 Pro',
    width: 448,
    height: 998,
    pixelRatio: 2.75,
    platform: DevicePlatform.android,
    safeAreaTop: 36,
    safeAreaBottom: 48,
    cornerRadius: 40,
  );

  /// Samsung Galaxy S24 specifications.
  static const samsungS24 = DeviceSpec(
    name: 'Samsung S24',
    width: 360,
    height: 780,
    pixelRatio: 3,
    platform: DevicePlatform.android,
    safeAreaTop: 32,
    safeAreaBottom: 44,
    cornerRadius: 35,
  );

  /// Samsung Galaxy Tab S9 specifications.
  static const samsungTabS9 = DeviceSpec(
    name: 'Samsung Tab S9',
    width: 800,
    height: 1280,
    pixelRatio: 2,
    platform: DevicePlatform.android,
    safeAreaTop: 24,
    safeAreaBottom: 24,
    cornerRadius: 12,
  );

  // Desktop Devices

  /// MacBook Pro 14" specifications.
  static const macBookPro14 = DeviceSpec(
    name: 'MacBook Pro 14"',
    width: 1512,
    height: 982,
    pixelRatio: 2,
    platform: DevicePlatform.desktop,
    cornerRadius: 10,
  );

  /// Windows Laptop (generic 1920x1080) specifications.
  static const windowsLaptop = DeviceSpec(
    name: 'Windows Laptop',
    width: 1920,
    height: 1080,
    pixelRatio: 1,
    platform: DevicePlatform.desktop,
  );

  /// All available iOS devices.
  static const List<DeviceSpec> iosDevices = [
    iPhone15Pro,
    iPhone15,
    iPhoneSE,
    iPadPro129,
    iPadMini,
  ];

  /// All available Android devices.
  static const List<DeviceSpec> androidDevices = [
    pixel8,
    pixel8Pro,
    samsungS24,
    samsungTabS9,
  ];

  /// All available desktop devices.
  static const List<DeviceSpec> desktopDevices = [
    macBookPro14,
    windowsLaptop,
  ];

  /// All available devices.
  static const List<DeviceSpec> allDevices = [
    ...iosDevices,
    ...androidDevices,
    ...desktopDevices,
  ];
}
