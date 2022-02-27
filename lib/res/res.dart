import 'dart:ui';

import 'package:flutter/material.dart';

class DimensConst {
  static const double headerWidgetHeight = 324.0;

  static const EdgeInsets minimumTopPadding = EdgeInsets.only(top: 8.0);
  static const EdgeInsets minimumLeftPadding = EdgeInsets.only(left: 8.0);
  static const EdgeInsets minimumRightPadding = EdgeInsets.only(right: 8.0);
  static const EdgeInsets minimumBottomPadding = EdgeInsets.only(bottom: 8.0);

  static const EdgeInsets mediumTopPadding = EdgeInsets.only(top: 16.0);
  static const EdgeInsets largeTopPadding = EdgeInsets.only(top: 24.0);

  static const EdgeInsets minimumOverallPadding = EdgeInsets.all(8.0);
  static const EdgeInsets mediumOverallPadding = EdgeInsets.all(16.0);
  static const EdgeInsets largeOverallPadding = EdgeInsets.all(24.0);

  static const EdgeInsets routeContentPadding = EdgeInsets.all(28.0);

  static const double avatarRadius = 16.0;
}

class DesignConst {
  static ColorScheme appSwatch = const ColorScheme.light(
    primary: Color(0xFFFF5556),
    secondary: Color(0xFFCAD5BC),
    // tertiary: Color(0xFF818181),
    tertiary: Color(0xFFF2F3F8),
    surface: Colors.white,
  );

  static ThemeData appTheme = ThemeData(
    brightness: Brightness.light,

    // primaryColor: Color(0xFFED6A5A),
    // primaryColor: const Color(0xFFFF5556),
    // primaryColorDark: const Color(0xFFF54748),
    // primaryColorLight: const Color(0xFFE88783),

    colorScheme: appSwatch,
    fontFamily: 'Avenir',

    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w600),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 25,
        shadowColor: appSwatch.primary.withAlpha(80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
    ),

    chipTheme: ChipThemeData.fromDefaults(
      primaryColor: appSwatch.primary,
      secondaryColor: appSwatch.secondary,
      labelStyle: const TextStyle(color: Colors.white),
    ).copyWith(
      shadowColor: Colors.transparent,
    ),
  );
}
