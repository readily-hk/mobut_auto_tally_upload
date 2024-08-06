import 'dart:io';
import 'package:flutter/material.dart';
import 'web_pdf_page.dart';
import '../theme_constants.dart';

class GeneratePdfPage extends StatefulWidget {
  File generatedPdf;
  String websiteLink;
  List<String> picturesPath;

  GeneratePdfPage(this.websiteLink, this.picturesPath,
      {required this.generatedPdf, Key? key})
      : super(key: key);
  @override
  _GeneratePdfPageState createState() => _GeneratePdfPageState();
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("掃描文檔預覽")),
        body: Stack(children: [
          backgroundWidget(),
          Container(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                const Text("確認已掃描作文",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                const SizedBox(height: 30),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  RichText(
                    text: new TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(fontSize: 15.0, color: Colors.black),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                '1️⃣   檢查下例文章預覽的頁數順序是否正確排列\n\n2️⃣   文字對齊並清晰可見\n\n3️⃣'),
                        new TextSpan(
                            text: '【極重要】',
                            style: new TextStyle(color: Colors.red)),
                        new TextSpan(
                            text:
                                '確保已裁去邊框以外的所有文字(包括學校名稱、學生名稱等一切非文章內容的資訊)，只留下邊框內的方格'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  const Divider(),
                  SizedBox(height: 20),
                  Text(
                    "文章預覽",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  for (var picture in widget.picturesPath)
                    Image.file(File(picture)),
                  const SizedBox(height: 65),
                ]),
              ]),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 30,
            right: 30,
            child: Container(width: 200, child: nextStepButton(context)),
          )
        ]));
  }

  ElevatedButton nextStepButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewPdfContainer(
                    widget.websiteLink,
                    pdf: widget.generatedPdf,
                  )),
        );
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
            const Size(200, 45)), // Set width and height of the button
      ),
      child: const Text("確認",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
    );
  }
}
