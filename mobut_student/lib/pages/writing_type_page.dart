import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme_constants.dart';
import 'scan_notice_page.dart';
import 'web_page.dart';
import 'qr_scanner_page.dart';
import 'web_local_file_page.dart';

class WritingTypePage extends StatelessWidget {
  String websiteLink;
  WritingTypePage(this.websiteLink, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const QRScannerPage()));
            },
          ),
        ),
        body: Stack(children: [
          backgroundWidget(),
          Container(
              padding: const EdgeInsets.all(25),
              child: Column(children: [
                const SizedBox(height: 50),
                SvgPicture.asset('assets/icons/choose-alt.svg',
                    width: 100, height: 100, color: const Color(0xFF11ae8f)),
                const SizedBox(height: 10),
                const Text("文章類型",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                const SizedBox(height: 25),
                const Text("选择适用的文章类型",
                    style: TextStyle(fontSize: 14, color: Color(0xFF9095A1))),
                const SizedBox(height: 35),
                writingTypeCard("電腦字", "電腦輸入文章", 'assets/icons/computer.svg',
                    "computer-text", context),
                const SizedBox(height: 15),
                writingTypeCard("手寫字-掃描", "一鍵掃描作文原稿紙",
                    'assets/icons/attribution-pen.svg', "scan", context),
                const SizedBox(height: 15),
                writingTypeCard("手寫字-選取文件", "從手機上載已掃描的文件",
                    'assets/icons/attribution-pen.svg', "local-file", context),
              ]))
        ]));
  }

  GestureDetector writingTypeCard(String title, String description,
      String iconName, String submitType, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (submitType == "scan") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScanNoticePage(websiteLink)),
          );
        } else if (submitType == "computer-text") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebPage(websiteLink)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebLocalFilePage(websiteLink)),
          );
        }
      },
      child: cardContentLayout(iconName, title, description),
    );
  }
}
