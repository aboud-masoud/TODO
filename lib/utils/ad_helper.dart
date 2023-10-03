import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-0120000896649737/6192362816';
      } else {
        return 'ca-app-pub-0120000896649737/6886487951';
      }
    } else {
      return "";
    }
  }
}
