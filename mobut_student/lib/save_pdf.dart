import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

class SaveDocument {
  static Future<File> savePdf({
    required String name,
    required Document pdf,
  }) async {
    dynamic root;
    if (Platform.isAndroid){
      root = await getExternalStorageDirectory();
    }
    else{
      root = await getApplicationDocumentsDirectory();
    }
    
    final file = File('${root!.path}/$name');
    await file.writeAsBytes(await pdf.save());
    debugPrint('${root.path}/$name');
    return file;
  }
}
