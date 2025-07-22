import 'package:flutter/material.dart';

class FontHelper {
  /// Euclid Circular A font with fallback to system fonts if a glyph is missing.
  static TextStyle euclidCircularA({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
    TextOverflow? overflow,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: 'EuclidCircularA',
      fontFamilyFallback: const [
        'sans-serif',
        '.SF UI Text',
        'Roboto',
      ],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      shadows: shadows,
      overflow: overflow,
      fontStyle: fontStyle,
    );
  }
}