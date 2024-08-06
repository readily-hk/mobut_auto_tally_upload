import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import '../javascript_webview.dart';
import '../theme_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class WebViewPdfContainer extends StatefulWidget {
  final File pdf;
  String websiteLink;
  WebViewPdfContainer(this.websiteLink, {Key? key, required this.pdf})
      : super(key: key);

  @override
  _WebViewPdfContainerState createState() => _WebViewPdfContainerState(pdf);
}

class _WebViewPdfContainerState extends State<WebViewPdfContainer> {
  late final WebViewController controller;
  final File pdf;
  bool _isFormFillingPage = true;

  _WebViewPdfContainerState(this.pdf);

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
      ..loadRequest(Uri.parse(widget.websiteLink + "?format=hand_writing"))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _injectFileUploadJS();
            injectNewPageDetectionJS(controller);
          },
        ),
      );
    //run below listener to overide webview's setonshowfileselector
    addFileSelectionListener();

    controller.clearCache();
    controller.clearLocalStorage();
    super.initState();
  }

  void _injectFileUploadJS() {
    final jsCode = '''
      function uploadFile(fileData, fileName) {
        var fileInput = document.querySelector('input[type="file"]');
        if (!fileInput) {
          console.error('File input not found');
          return;
        }

        var dataTransfer = new DataTransfer();
        var file = new File([fileData], fileName, {type: 'application/pdf'});
        dataTransfer.items.add(file);
        fileInput.files = dataTransfer.files;

        var event = new Event('change', { bubbles: true });
        fileInput.dispatchEvent(event);
      }
    ''';

    controller.runJavaScript(jsCode);
  }

  Future<void> _uploadFile() async {
    final bytes = await widget.pdf.readAsBytes();
    final base64 = base64Encode(bytes);
    final fileName = widget.pdf.path.split('/').last;

    final uploadJS = '''
      var fileData = Uint8Array.from(atob('$base64'), c => c.charCodeAt(0));
      uploadFile(fileData, '$fileName');
    ''';

    await controller.runJavaScript(uploadJS);
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
    final file = pdf;

    return [file.uri.toString()];
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
      floatingActionButton: _isFormFillingPage
          ? FloatingActionButton.extended(
              label: Text("點擊以自動上載作文"),
              icon: Icon(Icons.upload_file),
              foregroundColor: Colors.white,
              backgroundColor: grassGreen,
              onPressed: _uploadFile,
            )
          : backToQrScannerButton(context),
    );
  }
}
