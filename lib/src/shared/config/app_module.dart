import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import 'app_env.dart';

/// Third-party objects that injectable cannot construct by itself.
@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// For secrets such as tokens. Use [SharedPreferences] for plain settings.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    // Not in backups and never moved to another device.
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @lazySingleton
  Dio get dio => ApiClient.create(baseUrl: Env.apiBaseUrl);
}
