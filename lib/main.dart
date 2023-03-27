import 'package:flutter/material.dart';
import 'package:my_pet_opd/professional_info.dart';
import 'package:my_pet_opd/slot_selection.dart';
import 'package:my_pet_opd/splashscreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_home.dart';
import 'educational_info.dart';
import 'log_in.dart';
import 'notification.dart';
import 'personal_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isLogin = sp.getBool('login') ?? false;
  bool eductaion = sp.getBool('educationalinfo') ?? false;
  bool slot = sp.getBool('slotselection') ?? false;
  bool professional = sp.getBool('professionalinfo') ?? false;
  bool personal = sp.getBool('personalinfo') ?? false;
  String isID = sp.getString('userid') ?? "";

  OneSignal.shared.setAppId("8400a9dc-f9bf-49cd-a74e-ff6194200af3");
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  OneSignal.shared.setNotificationOpenedHandler((value) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => const Notifications(),
      ),
    );
  });

  runApp(
     const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
      // isLogin
      //     ? Home()
      //     : isID.isEmpty
      //         ? LogIn()
      //         : professional
      //             ? SlotSelection()
      //             : eductaion
      //                 ? ProfessionalInfo()
      //                 : personal
      //                     ? EductaionalInfo()
      //                     : PersonalInfo(),
    ),
  );
}
