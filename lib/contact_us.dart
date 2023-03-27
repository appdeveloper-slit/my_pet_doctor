import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bn_home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class ContactUs extends StatefulWidget {
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: SvgPicture.asset(
              'assets/back.svg',
            ),
          ),
        ),
        title: Text(
          'Contact Us',
          style: Sty()
              .largeText
              .copyWith(color: Clr().accentColor, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              child: Column(
                children: [
                  Image.asset('assets/contact_banner.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Contact Information',
                    style: Sty().largeText.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text('Have any query contact us',
                      style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(height: 20),
                  InkWell(onTap: (){
                    STM().openDialer('+919833522077');
                  },child: SvgPicture.asset('assets/phone.svg')),
                  SizedBox(
                    height: 12,
                  ),
                  Text('+919833522077'),
                  SizedBox(height: 20),
                  InkWell(onTap: () async {
                    const uri = 'mailto:mypet.opd@gmail.com';
                    await launch(uri);
                  },child: SvgPicture.asset('assets/mail.svg')),
                  SizedBox(
                    height: 12,
                  ),
                  Text('mypet.opd@gmail.com'),
                  SizedBox(height: 20),
                  InkWell(onTap: ()async{
                    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=House No. 3 At Post Ambeli, Dodamarg, Sindhudurg Maharashtra 416512 INDIA';
                    await launch(googleUrl);
                  },child: SvgPicture.asset('assets/location.svg')),
                  SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        'House No. 3 At Post Ambeli, Dodamarg, Sindhudurg Maharashtra 416512 INDIA',
                        textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
