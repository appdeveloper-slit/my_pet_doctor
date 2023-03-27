import 'package:flutter/material.dart';
import '../bn_home.dart';
import '../manage/static_method.dart';
import '../bn_my_wallet.dart';
import '../bn_patient.dart';
import '../bn_profile.dart';
import '../values/colors.dart';

Widget bottomBarLayout(ctx, index) {
  return BottomNavigationBar(
    elevation:50,
    backgroundColor: Clr().white,
    selectedItemColor: Clr().grey,
    unselectedItemColor: Clr().grey,
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (i) async {
      switch (i) {
        case 0:
          STM().finishAffinity(ctx, Home());
          break;
        case 1:
         index == 1 ? STM().replacePage(ctx,  MyWallet())  : STM().redirect2page(ctx,  MyWallet());
          break;
        case 2:
          index == 2 ? STM().replacePage(ctx,  Patient()) : STM().redirect2page(ctx,  Patient());
          break;
        case 3:
        index == 3 ? STM().replacePage(ctx,  MyProfile()) : STM().redirect2page(ctx,  MyProfile());
          break;
      }
    },
    items: STM().getBottomList(index),
  );
}