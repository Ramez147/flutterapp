// global_font_size.dart
import 'package:flutter/material.dart';

class GlobalFontSize {
  static final ValueNotifier<double> size = ValueNotifier<double>(16.0);
  
  static double get currentSize => size.value;
  
  static void increase() {
    if (size.value < 24) size.value += 1;
  }
  
  static void decrease() {
    if (size.value > 12) size.value -= 1;
  }
  
  static void set(double newSize) {
    if (newSize >= 12 && newSize <= 24) {
      size.value = newSize;
    }
  }
  
  static void reset() {
    size.value = 16.0;
  }
}