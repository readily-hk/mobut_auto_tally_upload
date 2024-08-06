import 'package:webview_flutter/webview_flutter.dart';

//determine whether the user submitted the form based on whether the submit button exist
//if there is a submit button, then the user is still filling the form
//if there isn't a submit button, then the user have submitted the form
void injectNewPageDetectionJS(WebViewController controller) {
  final jsCode = '''
      function checkForNewPage() {
        var submitButton = document.querySelector('button[type="submit"]');
        if (!submitButton) {
          FlutterChannel.postMessage('newPageDetected');
        } else {
          setTimeout(checkForNewPage, 500); // Check again after 500ms
        }
      }
      checkForNewPage();
    ''';

  controller.runJavaScript(jsCode);
}
