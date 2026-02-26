import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  final Color blackColor;

  const CustomThemeColors({

    required this.blackColor,
  });

  // Predefined themes for light and dark modes
  factory CustomThemeColors.light() => const CustomThemeColors(

    blackColor: Color(0xFF000000),
  );

  factory CustomThemeColors.dark() => const CustomThemeColors(

    blackColor: Color(0xFF000000),
  );

  @override
  CustomThemeColors copyWith({
    Color? blackColor,
  }) {
    return CustomThemeColors(
        blackColor: blackColor ?? this.blackColor,
    );
  }

  @override
  CustomThemeColors lerp(ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) return this;

    return CustomThemeColors(
      blackColor: Color.lerp(blackColor, other.blackColor, t)!,
    );
  }
}