import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:file_picker/file_picker.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import '../javascript_webview.dart';

import '../theme_constants.dart';

class WebLocalFilePage extends StatefulWidget {
  String websiteLink;
  WebLocalFilePage(this.websiteLink, {Key? key}) : super(key: key);

  @override
  _WebLocalFilePageState createState() => _WebLocalFilePageState();
}

class _WebLocalFilePageState extends State<WebLocalFilePage> {
  bool _isFormFillingPage = true;
  late final WebViewController controller;

  _WebLocalFilePageState();

  @override
  void initState() {
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
      ..loadRequest(Uri.parse(widget.websiteLink + "?format=hand_writing"));

    //run below listener to overide webview's setonshowfileselector
    addFileSelectionListener();
    controller.clearCache();
    controller.clearLocalStorage();
    super.initState();
  }

  void addFileSelectionListener() async {
    if (Platform.isAndroid) {
      //By casting controller.platform to AndroidWebViewController, you are accessing an Android-specific implementation of the webview controller that allows you to perform platform-specific actions or configurations related to the webview on Android devices.
      final androidController = controller.platform as AndroidWebViewController;

      // setOnShowFileSelector: Sets the callback that is invoked when the client should show a file selector.
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  //The FileSelectorParams object is a parameter that is passed automatically by the webview controller when invoking the file selection callback function. It contains information about the file selection event, such as accepted file types, multiple file selection support, etc.
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
