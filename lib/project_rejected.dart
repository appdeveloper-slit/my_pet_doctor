import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class RejectAccept extends StatefulWidget {
  @override
  State<RejectAccept> createState() => _RejectAcceptState();
}

class _RejectAcceptState extends State<RejectAccept> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        toolbarHeight: Dim().d80,
        backgroundColor: Clr().white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(Dim().d8),
          child: InkWell(
              onTap: () {
                // scaffoldState.currentState?.openDrawer();
              },
              child: SvgPicture.asset('assets/menu.svg')),
        ),
        centerTitle: true,
        title: SvgPicture.asset('assets/logo.svg'),
        actions: [
          Padding(
            padding: EdgeInsets.all(Dim().d8),
            child: InkWell(
                onTap: () {
                  // STM().redirect2page(ctx, RejectAccept());
                },
                child: SvgPicture.asset('assets/bell.svg')),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, Home());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/info.svg'),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Your Profile is Rejected',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                'Your profile has been rejected due to the following reason - %reason%',
                textAlign: TextAlign.center,
                // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                style: Sty().smallText.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Clr().black)),
            SizedBox(
              height: 20,
            ),
            Text('You can modify your details from My Profile screen',
                textAlign: TextAlign.center,
                // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                style: Sty().smallText.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Clr().black)),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, Home());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      'Visit My Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Divider(),
            SizedBox(
              height: Dim().d20,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 265,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, Home());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/info.svg'),
                        SizedBox(
                          width: 12,
                        ),
                        Center(
                          child: Text(
                            'Your Profile is under review',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
                'Your profile is under review, our team will check the details submitted by you and may even contact you for any further information.',
                textAlign: TextAlign.center,
                // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                style: Sty().smallText.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Clr().black)),
            SizedBox(
              height: 20,
            ),
            Text(
                'Once approved, you can start adding patients & receive the Video Consultation & OPD appointments',
                textAlign: TextAlign.center,
                // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                style: Sty().smallText.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Clr().black)),
            SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, Home());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      'Visit My Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
