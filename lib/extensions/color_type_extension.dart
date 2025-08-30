import 'package:flutter/material.dart';
import '../types.dart';

extension ColorTypeExtension on ColorType {
  Color get color {
    switch (this) {
      case ColorType.red:
        return Colors.red;
      case ColorType.green:
        return Colors.green;
      case ColorType.blue:
        return Colors.blue;
    }
  }
}
