import 'package:flutter/material.dart';

extension SnackBarHelper on BuildContext {
  static const _duration = Duration(seconds: 2);
  static const _behavior = SnackBarBehavior.floating;
  static final _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  void showSuccessSnackBar({required String content}) {
    final snackBar = SnackBar(
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(0, 0, 255, 55),
      behavior: _behavior,
      duration: _duration,
      shape: _shape,
    );
    _showSnackBar(snackBar);
  }

  void showErrorSnackBar({required String content}) {
    final snackBar = SnackBar(
      content: Text(
        content,
        style: const TextStyle(fontSize: 14, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red,
      behavior: _behavior,
      duration: _duration,
      shape: _shape,
    );
    _showSnackBar(snackBar);
  }

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
