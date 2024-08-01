import 'package:flutter/material.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  String websiteLink;
  File generatedPdf;

  PdfViewerPage(this.websiteLink, this.generatedPdf, {super.key});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("作文掃描件預覽"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Custom navigation logic here
              // For example, navigate to a specific page instead of going back
              Navigator.pop(context);
            },
          ),
        ),
        body: SfPdfViewer.file(widget.generatedPdf));
  }
}
