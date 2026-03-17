import 'dart:io';

import 'package:flutter/services.dart';

abstract final class PlatformUtils {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;

  /// Haptic при тапе на ячейку.
  static void triggerCellTap() {
    if (isIOS) {
      HapticFeedback.selectionClick();
    } else {
      HapticFeedback.lightImpact();
    }
  }
}
