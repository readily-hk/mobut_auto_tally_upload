import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:file_picker/file_picker.dart';
import '../javascript_webview.dart';
import '../theme_constants.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class WebPage extends StatefulWidget {
  String websiteLink;
  WebPage(this.websiteLink, {Key? key}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController controller;
  bool _isFormFillingPage = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'newPageDetected') {
            setState(() {
              _isFormFillingPage = false;
            });
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            injectNewPageDetectionJS(controller);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.websiteLink + "?format=computer"));

    addFileSelectionListener();
  }

  void addFileSelectionListener() async {
    if (Platform.isAndroid) {
      final androidController = controller.platform as AndroidWebViewController;
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      return [file.uri.toString()];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _isFormFillingPage
            ? AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    controller.clearCache();
                    controller.clearLocalStorage();
                    Navigator.of(context).pop();
                  },
                ),
              )
            : null,
        body: WebViewWidget(controller: controller),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
            visible: !_isFormFillingPage,
            child: backToQrScannerButton(context)));
  }
}
