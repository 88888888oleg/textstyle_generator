import 'package:flutter/material.dart';

class Palette {
  Palette._();

  static final Palette _instance = Palette._();

  factory Palette() => _instance;

  Brightness _brightness = Brightness.light;

  set brightness(Brightness brightness) {
    _brightness = brightness;
    WidgetsFlutterBinding.ensureInitialized()
        .performReassemble();
  }

  Color black() {
    switch (_brightness) {
      case Brightness.light:
        return _black;
      case Brightness.dark:
        return _white;
    }
  }

  static const _black = Color(0xFF000000);
  static const _white = Color(0xFFFFFFFF);
}
