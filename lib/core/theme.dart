import 'package:flutter/material.dart';

const ink = Color(0xff222222);
const coral = Color(0xffee998d);
const mint = Color(0xffa5d9cf);
const paper = Color(0xfff2f2f2);
const muted = Color(0xff999999);
const sea = Color(0xffdfedeb);

ThemeData appTheme(bool dark) {
  final scheme = ColorScheme.fromSeed(
    seedColor: coral,
    brightness: dark ? Brightness.dark : Brightness.light,
    primary: dark ? mint : ink,
    secondary: coral,
    surface: dark ? const Color(0xff303030) : Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: dark ? ink : paper,
    textTheme: ThemeData(
      brightness: scheme.brightness,
    ).textTheme.apply(fontFamily: 'Montserrat'),
    dividerColor: dark ? Colors.white12 : const Color(0xffdddddd),
    splashFactory: InkRipple.splashFactory,
    appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: muted)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: coral)),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: coral,
      thumbColor: Colors.white,
      inactiveTrackColor: Color(0xffdddddd),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected) ? mint : const Color(0xffdddddd),
      ),
    ),
  );
}
