import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-0120000896649737/8804044322';
      } else {
        return 'ca-app-pub-0120000896649737/6886487951';
      }
    } else {
      return "";
    }
  }
}
