import 'package:flutter/material.dart';
import 'package:my_pet_opd/personal_info.dart';
import 'package:my_pet_opd/professional_info.dart';
import 'package:my_pet_opd/register.dart';
import 'package:my_pet_opd/slot_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'educational_info.dart';
import 'log_in.dart';
import 'manage/static_method.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getsession() async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      bool isLogin = sp.getBool('login') ?? false;
      bool eductaion = sp.getBool('educationalinfo') ?? false;
      bool slot = sp.getBool('slotselection') ?? false;
      bool professional = sp.getBool('professionalinfo') ?? false;
      bool personal = sp.getBool('personalinfo') ?? false;
      String isID = sp.getString('userid') ?? "";
      setState(() {
        isLogin
            ? STM().finishAffinity(context, Home())
            : isID.isEmpty
            ? STM().finishAffinity(context, Register())
            : professional
            ? STM().finishAffinity(context, SlotSelection())
            : eductaion
            ? STM().finishAffinity(context, ProfessionalInfo())
            : personal
            ? STM().finishAffinity(context, EductaionalInfo())
            : STM().finishAffinity(context, PersonalInfo());
      });
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),(){
      getsession();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Image.asset('assets/splash_screen.png',fit: BoxFit.cover,),
      ),
    );
  }
}
