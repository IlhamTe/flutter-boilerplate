import 'package:material_ui/material_ui.dart';

import '../assets/colors.gen.dart';
import '../assets/fonts.gen.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  /// Brand colors from assets/colors/colors.xml, as they are.
  static final light = _theme(
    ColorScheme.fromSeed(
      seedColor: ColorName.primary,
      primary: ColorName.primary,
      secondary: ColorName.secondary,
      error: ColorName.error,
    ),
  );

  /// Derived from the brand color: the light-theme values are too dark to
  /// read on a dark background.
  static final dark = _theme(
    ColorScheme.fromSeed(
      seedColor: ColorName.primary,
      brightness: Brightness.dark,
    ),
  );

  static ThemeData _theme(ColorScheme colorScheme) => ThemeData(
    colorScheme: colorScheme,
    fontFamily: FontFamily.poppins,
    // Merged onto the default typography, which adds the theme's text colors.
    textTheme: AppTextStyles.textTheme,
  );
}
