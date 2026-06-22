import 'dart:math';

import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Function()? onPressed;
  final bool Function()? isActive;
  final String text;
  final double? borderRadius;
  final Gradient? gradient;
  final Widget? suffixIcon;
  const AppElevatedButton({
    super.key,
    this.width,
    this.height,
    this.color,
    this.isActive,
    required this.text,
    this.onPressed,
    this.textColor,
    this.borderRadius,
    this.borderColor,
    this.gradient,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final deActivated = isActive != null && !isActive!();
    return InkWell(
      onTap: deActivated ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width ?? (min(MediaQuery.of(context).size.width, 500)),
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          color:
              deActivated
                  ? (color ?? const Color.fromARGB(0, 0, 255, 55)).withValues(
                    alpha: .4,
                  )
                  : (color ?? const Color.fromARGB(0, 0, 255, 55)),
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          border: Border.all(
            color:
                deActivated
                    ? (borderColor ?? const Color.fromARGB(0, 0, 255, 55))
                        .withValues(alpha: .4)
                    : (borderColor ?? const Color.fromARGB(0, 0, 255, 55)),
          ),
        ),
      ),
    );
  }
}
