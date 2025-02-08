// lib/theme/balot_movies_colors.dart
import 'package:flutter/material.dart';

class BalotMoviesColors {
  // Colores principales
  static const Color redPrimary = Color.fromARGB(255, 185, 0, 0);
  static const Color redDark = Color.fromARGB(255, 75, 0, 0);
  static const Color yellow = Color.fromARGB(255, 255, 217, 0);
  
  // Colores para texto
  static const Color textLight = Colors.white;
  static const Color textDark = Colors.black87;
  
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? textLight 
        : textDark;
  }
  
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.black 
        : Colors.white;
  }
}