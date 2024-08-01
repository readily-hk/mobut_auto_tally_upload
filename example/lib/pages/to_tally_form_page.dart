import 'package:flutter/material.dart';
import 'web_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme_constants.dart';
import 'qr_scanner_page.dart';

class ToTallyFormPage extends StatelessWidget {
  String websiteLink;
  ToTallyFormPage(this.websiteLink, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("作文提交"),
        ),
        body: Stack(children: [
          backgroundWidget(),
          Container(
              padding: EdgeInsets.all(25),
              child: Column(children: [
                Text("電腦作文提交",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                SizedBox(height: 25),
                Text("前往提交作文",
                    style: TextStyle(fontSize: 14, color: Color(0xFF9095A1))),
                SizedBox(height: 65),
                writingTypeCard("作文提交", "前往填寫表格並複製粘貼作文",
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
                builder: (context) => WebPage(websiteLink)),
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
