import 'package:material_ui/material_ui.dart';

import '../assets/fonts.gen.dart';

/// The one place for text styles.
///
/// The styles have no color, so text follows the theme (light and dark). Add a
/// color or another weight with `copyWith` where a design needs it.
/// [AppTheme] also uses [textTheme], so Material widgets (AppBar, buttons,
/// dialogs) get the same font and sizes.
abstract final class AppTextStyles {
  static const _family = FontFamily.poppins;

  static const h1 = TextStyle(
    fontFamily: _family,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const h2 = TextStyle(
    fontFamily: _family,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const h3 = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const body = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const caption = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const button = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const textTheme = TextTheme(
    headlineSmall: h1,
    titleLarge: h2,
    titleMedium: h3,
    bodyLarge: bodyLarge,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: button,
  );
}
