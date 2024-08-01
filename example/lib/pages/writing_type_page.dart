import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme_constants.dart';
import 'scan_notice_page.dart';
import 'to_tally_form_page.dart';
import 'qr_scanner_page.dart';

class WritingTypePage extends StatelessWidget {
  String websiteLink;
  WritingTypePage(this.websiteLink, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("「巫筆」學生作文繳交平台"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Custom navigation logic here
              // For example, navigate to a specific page instead of going back
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => QRScannerPage()));
            },
          ),
        ),
        body: Stack(children: [
          backgroundWidget(),
          Container(
              padding: EdgeInsets.all(25),
              child: Column(children: [
                Text("文章類型",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                SizedBox(height: 25),
                Text("选择适用的文章类型",
                    style: TextStyle(fontSize: 14, color: Color(0xFF9095A1))),
                SizedBox(height: 65),
                writingTypeCard("手寫字", "轻松掃描写作原稿纸",
                    'assets/icons/attribution-pen.svg', true, context),
                SizedBox(height: 27),
                writingTypeCard("電腦字", "输入或复制粘贴文章", 'assets/icons/computer.svg',
                    false, context),
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) =>
                //                 ScannedBarcodeLabel()),
                //       );
                //     },
                //     child: const Text("文章選擇")),
              ]))
        ]));
  }

  GestureDetector writingTypeCard(String title, String description,
      String iconName, bool isHandWriting, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isHandWriting) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanNoticePage(websiteLink)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ToTallyFormPage(websiteLink)),
          );
        }
      },
      child: Container(
        width: 330,
        height: 110,
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
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Ensure text starts from the left
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF245130))),
              SizedBox(height: 10),
              Text(description,
                  style: TextStyle(fontSize: 14, color: Color(0xFF9095A1)))
            ],
          ),
        ]),
      ),
    );
  }
}
