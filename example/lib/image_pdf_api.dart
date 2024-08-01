import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import '/save_pdf.dart';
import 'dart:typed_data';
import 'dart:async';

import 'package:image/image.dart' as img;

class ImagePdfApi {
  static Future<File> generateImagePdf(List<String> _paths) async {
    final pdf = Document();

    for (var path in _paths) {
      Uint8List imageBytes = await File(path).readAsBytes();
      final completer = Completer<img.Image>();
      img.Image? image;

      try {
        image = img.decodeImage(imageBytes);
        if (image != null) {
          completer.complete(image);
        }
      } catch (e) {
        print('Error decoding image: $e');
      }

      final loadedImage = await completer.future;
      final imageWidth = loadedImage.width.toDouble();
      final imageHeight = loadedImage.height.toDouble();

      final pdfPageFormat = PdfPageFormat(imageWidth, imageHeight);

      pdf.addPage(
        Page(
          pageFormat: pdfPageFormat,
          build: (Context context) {
            return Center(
              child: Image(
                MemoryImage(imageBytes),
                width: imageWidth,
                height: imageHeight,
              ),
            );
          },
        ),
      );
    }

    return SaveDocument.savePdf(name: 'image_pdf.pdf', pdf: pdf);
  }
}
