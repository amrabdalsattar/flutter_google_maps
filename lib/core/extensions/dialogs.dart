import 'package:flutter/material.dart';

import '../widgets/app_elevated_button.dart';

extension DialogHelper on BuildContext {
  void showAlertDialog({
    required String title,
    required String subTitle,
    String? denialText,
    String? confirmText,
    void Function()? onConfirm,
    void Function()? onCancel,
    bool barrierDismissible = true,
    Color? buttonColor,
  }) {
    showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subTitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          text: 'Cancel',
                          height: 38,
                          onPressed: onCancel ?? () => Navigator.pop(this),
                          color: buttonColor ?? Colors.red,
                          borderColor: buttonColor ?? Colors.red,
                          borderRadius: 30,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppElevatedButton(
                          height: 38,
                          text: confirmText ?? 'Confirm',
                          color: Colors.white,
                          borderColor: buttonColor ?? Colors.red,
                          textColor: buttonColor ?? Colors.red,
                          borderRadius: 30,
                          onPressed: onConfirm ?? () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

extension BottomSheetExtension on BuildContext {
  Future<T?> showBottomSheet<T>({
    required Widget child,
    Color? backgroundColor,
    ShapeBorder? shape,
    Clip? clipBehavior,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: backgroundColor ?? Theme.of(this).canvasColor,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),

      clipBehavior: clipBehavior,
      builder: (_) => child,
    );
  }
}
