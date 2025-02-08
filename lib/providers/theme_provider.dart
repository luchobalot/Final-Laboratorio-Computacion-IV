import 'package:flutter/material.dart';
import 'package:final_api_laboratorio/helpers/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = Preferences.darkmode;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    Preferences.darkmode = value; // Guardar el estado en SharedPreferences
    notifyListeners(); // Notificar a los widgets que dependan del estado
  }
}