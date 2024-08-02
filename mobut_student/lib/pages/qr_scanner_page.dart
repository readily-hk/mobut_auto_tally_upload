import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../pop_up_card.dart';

import 'writing_type_page.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with WidgetsBindingObserver {
  bool _screenOpened = false;
  MobileScannerController cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal, returnImage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("作文二維碼掃描"), leading: Container()),
        backgroundColor: Colors.green.withOpacity(0.1),
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Expanded(
                  child: Container(
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                    Text("將作文二維碼置於框中",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ]))),
              Expanded(
                flex: 4,
                child: MobileScanner(
                  controller: cameraController,
                  onDetect: _foundBarcode,
                ),
              ),
              Expanded(child: Container()),
            ])));
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }

  void _foundBarcode(BarcodeCapture capture) {
    if (!_screenOpened) {
      List<Barcode> barcodes = capture.barcodes;
      _screenOpened = true;
      String code = barcodes[0].rawValue ?? "___";
      barcodes = [];

      if (code.contains("tally")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WritingTypePage(code)),
        ).then((_) {});

        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return PopUpCard(true, code);
        //     }).then((_) {
        //   _screenOpened = false;
        // });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return PopUpCard(false, code);
            }).then((_) {
          _screenOpened = false;
        });
      }
    }
  }
}
