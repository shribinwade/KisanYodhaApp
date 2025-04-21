import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return ".env.production";
    }
    return ".env.development";
  }

  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'API_BASE_URL not found';
  }
}
