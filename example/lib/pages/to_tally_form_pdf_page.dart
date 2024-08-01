import 'package:flutter/material.dart';
import 'web_pdf_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme_constants.dart';
import 'dart:io';
import 'qr_scanner_page.dart';

class ToTallyFormPdfPage extends StatelessWidget {
  final File filePdf;
  String websiteLink;
  ToTallyFormPdfPage(this.websiteLink, this.filePdf, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("作文提交")),
        body: Stack(children: [
          backgroundWidget(),
          Container(
              padding: EdgeInsets.all(25),
              child: Column(children: [
                Text("手寫作文提交",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                SizedBox(height: 25),
                Text("手寫作文的電子文檔已保存\n前往“作文提交”以自動上傳作文文檔",
                    style: TextStyle(fontSize: 14, color: Color(0xFF9095A1)),
                    textAlign: TextAlign.center),
                SizedBox(height: 65),
                writingTypeCard("作文提交", "前往填表並以電子文檔形式提交手寫作文",
                    'assets/icons/form.svg', true, context),
                SizedBox(height: 27),
                writingTypeCard("重新掃描作文二維碼", "爲了方便測試，暫時是去目錄",
                    'assets/icons/qr.svg', false, context),
              ]))
        ]));
  }

  GestureDetector writingTypeCard(String title, String description,
      String iconName, bool toTally, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (toTally) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPdfContainer(websiteLink,
                      pdf: filePdf,
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScannerPage()),
          );
        }
      },
      child: Container(
        width: 330,
        padding: EdgeInsets.only(left: 45, right: 45, top: 25, bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0x22171a1f),
              blurRadius: 12,
              offset: Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: Row(children: [
          SvgPicture.asset(iconName, width: 80, height: 50, color: grassGreen),
          SizedBox(width: 27),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Ensure text starts from the left
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF245130))),
                SizedBox(height: 10),
                Text(
                  description,
                  softWrap: true,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF9095A1)),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
