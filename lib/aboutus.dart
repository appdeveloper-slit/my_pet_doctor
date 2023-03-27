import 'package:flutter/material.dart';

import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        backgroundColor: Clr().primaryColor,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Clr().white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'About Us',
          style: Sty().largeText.copyWith(
              color: Clr().white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dim().d20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dim().d60,
            ),
            Text(
              'About Us',
              style: Sty().mediumBoldText,
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Text(
              "Mypet OPD is pioneered in Veterinary Telemedicine Application to connect Livestock , Pet , Exotics owners virtually through App for Veterinary Tele Consultations “. PASHU Health offers E- Consults at affordable rate & is convenient Mobile App based 24/7 Veterinary Telemedicine through specialist Vet Doctor for Rural farmers for equitable healthcare access to millions of Livestock Owners, Dairy Farmers & Pet Owners in India.",
              style: Sty().mediumBoldText,
            ),
          ],
        ),
      ),
    );
  }
}
