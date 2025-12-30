import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class ImagesUtils {
  static Future<Uint8List> getImageFromRawData(
    String imageUrl,
    double width,
  ) async {
    final imageData = await rootBundle.load(imageUrl);

    final imageCodec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width.round(),
    );
    final imageFrame = await imageCodec.getNextFrame();

    final imageByteData = await imageFrame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return imageByteData!.buffer.asUint8List();
  }
}
