// font_size_manager.dart
import 'package:flutter/material.dart';

class FontSizeManager {
  static final ValueNotifier<double> fontSize = ValueNotifier<double>(16.0);
  
  static void increase() {
    if (fontSize.value < 24) {
      fontSize.value += 1;
    }
  }
  
  static void decrease() {
    if (fontSize.value > 12) {
      fontSize.value -= 1;
    }
  }
}