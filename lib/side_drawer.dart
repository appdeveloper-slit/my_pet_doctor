import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutus.dart';
import 'bn_home.dart';
import 'bn_profile.dart';
import 'contact_us.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

Widget navbar(context, key,user) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        if (key.currentState.isDrawerOpen) {
          key.currentState.openEndDrawer();
        }
        return true;
      },
      child: Drawer(
        width: 275,
        child: user == null ? Container() : Container(
          decoration: BoxDecoration(color: Clr().white),
          child: WillPopScope(
            onWillPop: () async {
              if (key.currentState!.isDrawerOpen) {
                key.currentState!.openEndDrawer();
              }
              return true;
            },
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50,),
                        Text('${user['doctor'][0]['name'].toString()}',
                            style: Sty().largeText.copyWith(
                                color: Clr().primaryDarkColor,
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: Dim().d8,
                        ),
                        user['doctor'][0]['education'] == null ? Container() : Text('${user['doctor'][0]['education']['speciality_id'].toString()}',
                            style: Sty().mediumText.copyWith(
                                color: Clr().black, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xffABE68C)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_home.svg'),
                    title: Text(
                      'Home',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                        STM().finishAffinity(context, Home());
                        close(key);
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xffE683F0)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_profile.svg'),
                    title: Text(
                      'My Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                    STM().redirect2page(context, MyProfile());
                    close(key);
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xffF1B382)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_privacy.svg'),
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      STM().openWeb('https://mypetopd.com/privacy');
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xff828AEF)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_terms.svg'),
                    title: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      STM().openWeb('https://mypetopd.com/terms');
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xffFFB173)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_share.svg'),
                    title: Text(
                      'Share App',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                        var message = 'Download The MyPet Opd Doctor App from below link\n\nhttps://play.google.com/store/apps/details?id=com.doctor.mypetopd';
                        Share.share(message);
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xff269BFD)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_about.svg'),
                    title: Text(
                      'About Us',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      STM().redirect2page(context, AboutUs());
                      close(key);
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xff269BFD)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_contact.svg'),
                    title: Text(
                      'Contact Us',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      STM().redirect2page(context, ContactUs());
                      close(key);
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  // decoration: BoxDecoration(color: Color(0xff82BEF0)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/d_log_out.svg'),
                    title: Text(
                      'Log Out',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () async {
                        SharedPreferences sp =
                        await SharedPreferences.getInstance();
                        sp.setBool('is_login', false);
                        sp.clear();
                        STM().finishAffinity(context, LogIn());
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void close(key) {
  key.currentState.openEndDrawer();
}