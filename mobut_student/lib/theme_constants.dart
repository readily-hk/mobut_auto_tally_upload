import 'package:flutter/material.dart';
import 'pages/qr_scanner_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

Color grassGreen = Color(0xFF5F9F6D);
Color lightRed = Color(0xFFE79473);

ThemeData theme = ThemeData(
    fontFamily: 'NotoSansTC',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF000000))),
    ));

Container backgroundWidget() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/icons/background.png'),
        fit: BoxFit.cover, // Cover the whole container
        alignment: Alignment.bottomCenter, // Center the image
      ),
    ),
  );
}

Container cardContentLayout(String iconName, String title, String description) {
  return Container(
    width: 330,
    padding: EdgeInsets.only(left: 45, right: 45, top: 25, bottom: 25),
    decoration: cardBorderDesign(),
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
              style: const TextStyle(fontSize: 14, color: Color(0xFF9095A1)),
            ),
          ],
        ),
      )
    ]),
  );
}

Stack backToQrScannerButton(BuildContext context) {
  return Stack(children: [
    Positioned(
        bottom: 150,
        left: 60,
        right: 60,
        child: backToQrScannerButtonContent(context))
  ]);
}

FloatingActionButton backToQrScannerButtonContent(BuildContext context) {
  return FloatingActionButton.extended(
    label: Text("重新掃描二維碼,提交另一篇作文"),
    icon: Icon(Icons.qr_code_scanner),
    foregroundColor: Colors.white,
    backgroundColor: grassGreen,
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QRScannerPage()),
      );
    },
  );
}

BoxDecoration cardBorderDesign() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Color(0x22171a1f),
        blurRadius: 12,
        offset: Offset(0, 4), // Shadow position
      ),
    ],
  );
}
