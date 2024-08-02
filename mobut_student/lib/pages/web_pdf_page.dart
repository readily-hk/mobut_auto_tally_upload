import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
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

//issue with file upload: user have to manually touch anywhere of the page, and then auto file upload works
//why???
//document.querySelector('button[aria-label="Register"]').click(); code for automating register
  String autoFillJavaScript = '''
  document.querySelector('.sc-6663af1f-1.gvjUuC').click();

  function changeReactInputValue(inputDom,newText){
	  let lastValue = inputDom.value;
	  inputDom.value = newText;
	  let event = new Event('input', { bubbles: true });
	  event.simulated = true;
	  let tracker = inputDom._valueTracker;
	  if (tracker) {
  	  tracker.setValue(lastValue);
	  }
	  inputDom.dispatchEvent(event);
  }

  var userIdDom = document.getElementById("dd2bd7d8-4274-42b8-b7b7-6a3bc527ca47");
  changeReactInputValue(userIdDom,'username');
''';

  String autoUploadJavaScript = '''
  document.querySelector('.sc-6663af1f-1.gWsJwX').click();

  document.addEventListener('DOMContentLoaded', function () {

    document.querySelector('button').addEventListener('click', int)
});

function int() {
    console.log('calling');
    document.querySelector('.sc-6663af1f-1.gWsJwX').click();
}
''';
  String autoFillTextField = '''
  function changeReactInputValue(inputDom,newText){
	  let lastValue = inputDom.value;
	  inputDom.value = newText;
	  let event = new Event('input', { bubbles: true });
	  event.simulated = true;
	  let tracker = inputDom._valueTracker;
	  if (tracker) {
  	  tracker.setValue(lastValue);
	  }
	  inputDom.dispatchEvent(event);
  }

  var userIdDom = document.getElementById("dd2bd7d8-4274-42b8-b7b7-6a3bc527ca47");
  changeReactInputValue(userIdDom,'username');
  ''';

  String autoFillCheckbox = '''
  function changeReactCheckboxValue(inputDom, newValue) {
    let lastChecked = inputDom.checked;
    inputDom.checked = newValue;
    let event = new Event('change', { bubbles: true });
    event.simulated = true;
    inputDom.dispatchEvent(event);
    if (lastChecked !== newValue) {
        let clickEvent = new MouseEvent('click', { bubbles: true });
        clickEvent.simulated = true;
        inputDom.dispatchEvent(clickEvent);
    }
}

// Example usage
const checkboxElement = document.getElementById('checkbox_4231cd22-4eb1-48d4-b5e2-a5eb63c45b45');
changeReactCheckboxValue(checkboxElement, true);
  ''';

  _WebViewPdfContainerState(this.pdf);

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.websiteLink))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _injectFileUploadJS();
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
    final result = await FilePicker.platform.pickFiles();
    final file = pdf;

    return [file.uri.toString()];

    // final result = await FilePicker.platform.pickFiles();

    // if (result != null && result.files.single.path != null) {
    //   final file = File(result.files.single.path!);
    //   return [file.uri.toString()];
    // }
    // return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            controller.clearCache();
            controller.clearLocalStorage();

            Navigator.of(context).pop();
          },
        ),
      ),
      body: WebViewWidget(controller: controller),
      floatingActionButton: FloatingActionButton(
        child: Text("Upload"),
        onPressed: _uploadFile,
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Text("Autofill"),
      //     onPressed: () async {
      //       controller.runJavaScript(autoFillJavaScript);
      //     })
    );
  }
}


