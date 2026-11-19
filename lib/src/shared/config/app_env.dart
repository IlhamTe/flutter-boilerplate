import 'package:envied/envied.dart';

part 'app_env.g.dart';

/// Values from `.env`. After a change in `.env`, run `make generate`.
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL', obfuscate: true)
  static final String apiBaseUrl = _Env.apiBaseUrl;
}
