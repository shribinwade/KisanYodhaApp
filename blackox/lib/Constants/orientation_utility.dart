import 'package:flutter/services.dart';

class OrientationUtility {
  static List<DeviceOrientation>? _currentOrientations;

  /// Locks the screen orientation to portrait mode
  static Future<void> lockToPortrait() async {
    _currentOrientations = [DeviceOrientation.portraitUp];
    await SystemChrome.setPreferredOrientations(_currentOrientations!);
  }

  /// Locks the screen orientation to landscape mode
  static Future<void> lockToLandscape() async {
    _currentOrientations = [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ];
    await SystemChrome.setPreferredOrientations(_currentOrientations!);
  }

  /// Unlocks the screen orientation to allow both portrait and landscape
  static Future<void> unlockOrientation() async {
    _currentOrientations = [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ];
    await SystemChrome.setPreferredOrientations(_currentOrientations!);
  }

  /// Checks if the screen is currently locked to portrait
  static bool isPortraitLocked() {
    return _currentOrientations?.length == 1 &&
        _currentOrientations!.contains(DeviceOrientation.portraitUp);
  }

  /// Checks if the screen is currently locked to landscape
  static bool isLandscapeLocked() {
    return _currentOrientations?.length == 2 &&
        _currentOrientations!.contains(DeviceOrientation.landscapeLeft) &&
        _currentOrientations!.contains(DeviceOrientation.landscapeRight);
  }

  /// Checks if the screen orientation is unlocked
  static bool isOrientationUnlocked() {
    return _currentOrientations?.length == 4;
  }
}
