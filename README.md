# Flutter Boilerplate

Clean architecture without the domain/use-case layers: `data` (models, Retrofit services, repositories) and `features` (bloc managers, pages, widgets).

Stack: flutter_bloc, get_it + injectable, dio + retrofit, envied, auto_route, freezed, json_serializable, slang, flutter_secure_storage, shared_preferences, flutter_gen. Tests: bloc_test, mocktail.

## Start a new project

```sh
fvm use                                                      # links .fvm/ to the Flutter version in .fvmrc
make rename                                                  # asks for app name, bundle id, Dart package
make setup                                                   # creates .env, gets packages, generates code
make run
```

To change the launcher icon, replace the files in `assets/app_icon/` (`app_icon.png` 1024x1024 without transparency; `app_icon_foreground.png` transparent with the logo inside the center 61%; `app_icon_background.png`), then run `make icons`.

`make rename` asks three optional questions; press Enter to keep a value, and only what you fill in changes. It shows the changes and asks before it writes anything; with every answer empty it does nothing.

- App name: Android label, iOS display name, `appName` in `lib/i18n`.
- Bundle ID: Android applicationId/namespace and MainActivity package, iOS bundle id (`_` becomes `-`, iOS does not allow `_`).
- Dart package name: `pubspec.yaml` name, `package:` imports, iOS bundle name.

For CI, pass the values instead: `make rename BUNDLE_ID=com.company.my_app` (also `APP_NAME`, `PACKAGE_NAME`). It can run again later.

## Structure

```
lib/
  i18n/                 slang translations (*.i18n.json)
  src/
    data/<name>/        models/ services/ repositories/
    features/<name>/    managers/ pages/ widgets/
    shared/             config/ (DI, router, env, theme) network/ models/ components/ extensions/ utils/ assets/
  app.dart
  main.dart
```

`post` is the sample feature (service -> repository -> bloc -> page). Copy its pattern, then delete it.

## Assets, fonts, colors, text styles

Add a file under `assets/images/` or `assets/icons/`, a font in `pubspec.yaml`, or a color in `assets/colors/colors.xml`, then run `make generate`. flutter_gen writes typed accessors to `lib/src/shared/assets/`, so a typo is a compile error instead of a crash:

- `Assets.images.flutterBirdIllustration.image()`, `Assets.icons.icFlutter.image()`
- `FontFamily.poppins`
- `ColorName.primary`: brand colors. They feed `AppTheme`; widgets read `Theme.of(context).colorScheme`, and use `ColorName` only for one-off brand spots.

Text styles live in `lib/src/shared/config/app_text_styles.dart` (`AppTextStyles.h1`, `.body`, ...). They have no color, so they follow light and dark mode. `AppTheme` also sets them as the `TextTheme`.

## Commands

Run `make help` to list them. After a change in `.env`, annotations or `lib/i18n`, run `make generate` (or `make watch`).
