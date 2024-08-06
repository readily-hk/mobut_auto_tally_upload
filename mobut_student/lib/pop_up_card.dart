import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme_constants.dart';
import 'pages/writing_type_page.dart';
import 'pages/qr_scanner_page.dart';

class PopUpCard extends StatelessWidget {
  final bool scanSuccess;
  final String qrCode;

  const PopUpCard(this.scanSuccess, this.qrCode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            width: 350,
            height: 340,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(25),
            child: scanSuccess
                ? cardContentSuccess(context)
                : cardContentFail(context)));
  }

  Column cardContentSuccess(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 15),
      SvgPicture.asset('assets/icons/check-circle.svg',
          width: 100, height: 100, color: grassGreen),
      const SizedBox(height: 15),
      const Text("識別成功!",
          style: TextStyle(fontSize: 22, color: Color(0xFF171A1F))),
      const SizedBox(height: 10),
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WritingTypePage(qrCode)),
            ).then((_) {});
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
                const Size(270, 43)), // Set width and height of the button
          ),
          child: const Text("下一步"))
    ]);
  }

  Column cardContentFail(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 15),
      SvgPicture.asset('assets/icons/circle-xmark.svg',
          width: 100, height: 100, color: lightRed),
      const SizedBox(height: 15),
      const Text("掃描失敗!",
          style: TextStyle(fontSize: 22, color: Color(0xFF171A1F))),
      const SizedBox(height: 15),
      const Text("請按以下按鈕重新掃描",
          style: TextStyle(fontSize: 14, color: Color(0xFF9095A1))),
      const SizedBox(height: 30),
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
                const Size(270, 43)), // Set width and height of the button
          ),
          child: const Text("重新掃描"))
    ]);
  }
}
