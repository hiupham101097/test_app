import 'package:flutter/material.dart';

extension ColorMixExtension on Color {
  Color mixWith(Color other, double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0.0 and 1.0');

    int mixChannel(int a, int b) => ((a * (1 - amount)) + (b * amount)).round();

    return Color.fromARGB(
      mixChannel(alpha, other.alpha),
      mixChannel(red, other.red),
      mixChannel(green, other.green),
      mixChannel(blue, other.blue),
    );
  }
}
