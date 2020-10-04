import 'dart:math' show sqrt;

import 'package:flutter/material.dart';

class Tools {
  static bool isTablet(Size size) {
    final diagonal = sqrt(
      (size.width * size.width) + (size.height * size.height),
    );
    return diagonal > 1100.0;
  }

  static String formatDate(DateTime date) {
    if (date == null) return null;
    return '${date.day}/${date.month}/${date.year}';
  }

  static bool isNullOrEmpty(String s) => s == null || s.isEmpty;
}
