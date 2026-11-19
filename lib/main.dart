import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'i18n/strings.g.dart';
import 'src/shared/config/app_di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  await configureDependencies();

  runApp(TranslationProvider(child: const App()));
}
