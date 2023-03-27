import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/slot_selection.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'bn_home.dart';
import 'bn_home.dart';
import 'educational_info.dart';
import 'manage/static_method.dart';
import 'personal_info.dart';
import 'professional_info.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class OTPVerification extends StatefulWidget {
  final String? sType, sMobile, semail, sname;

  const OTPVerification(
      {Key? key, this.sType, this.sMobile, this.semail, this.sname})
      : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpCtrl = TextEditingController();
  bool again = false;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(ctx).size.height,
          child: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/otp_screen.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Dim().d32,
                    ),
                    InkWell(
                        onTap: () {
                          STM().back2Previous(ctx);
                        },
                        child: SvgPicture.asset('assets/back.svg')),
                    SizedBox(
                      height: Dim().d44,
                    ),
                    Center(
                      child: SvgPicture.asset('assets/logo.svg', width: 280),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'OTP Verification',
                        style: Sty().largeText.copyWith(
                            fontFamily: 'urban',
                            fontWeight: FontWeight.w600,
                            color: Clr().black,
                            fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d24,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'We’ve sent you the verification\ncode on +91 ${widget.sMobile}',
                        // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                        style: Sty().mediumText.copyWith(
                            fontFamily: 'urban',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: Clr().shimmerColor),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PinCodeTextField(
                      controller: otpCtrl,
                      // errorAnimationController: errorController,
                      appContext: context,
                      enableActiveFill: true,
                      textStyle: Sty().largeText,
                      length: 4,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      animationType: AnimationType.scale,
                      cursorColor: Clr().primaryDarkColor,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(Dim().d8),
                        fieldWidth: Dim().d60,
                        fieldHeight: Dim().d56,
                        selectedFillColor: Clr().transparent,
                        activeFillColor: Clr().transparent,
                        inactiveFillColor: Clr().transparent,
                        inactiveColor: Clr().lightGrey,
                        activeColor: Clr().primaryDarkColor,
                        selectedColor: Clr().lightGrey,
                      ),
                      animationDuration: const Duration(milliseconds: 200),
                      onChanged: (value) {},
                      // validator: (value) {
                      //   if (value!.isEmpty || !RegExp(r'(.{4,})').hasMatch(value)) {
                      //     return "";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Dim().d56,
                          width: Dim().d260,
                          child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  widget.sType == 'login'
                                      ? loginuser()
                                      : verifyotp();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Clr().primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(Dim().d8))),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: 'urban',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Visibility(
                                visible: !again,
                                child: TweenAnimationBuilder<Duration>(
                                    duration: const Duration(seconds: 60),
                                    tween: Tween(
                                        begin: const Duration(seconds: 60),
                                        end: Duration.zero),
                                    onEnd: () {
                                      // ignore: avoid_print
                                      // print('Timer ended');
                                      setState(() {
                                        again = true;
                                      });
                                    },
                                    builder: (BuildContext context,
                                        Duration value, Widget? child) {
                                      final minutes = value.inMinutes;
                                      final seconds = value.inSeconds % 60;
                                      return Column(
                                        children: [
                                          // Text(
                                          //   'Haven’t recived the verification code?',
                                          //   style: Sty()
                                          //       .mediumText
                                          //       .copyWith(color: Clr().grey),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "Re-send code in $minutes:$seconds",
                                              textAlign: TextAlign.center,
                                              style: Sty().mediumText.copyWith(
                                                    color: Clr().grey,
                                                    fontFamily: 'roboto',
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                            Visibility(
                              visible: again,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    again = false;
                                  });
                                  // STM.checkInternet().then((value) {
                                  //   if (value) {
                                  //     sendOTP();
                                  //   } else {
                                  //     STM.internetAlert(ctx, widget);
                                  //   }
                                  // });
                                  resendOTP(widget.sMobile);
                                },
                                child: Text(
                                  'Resend Code',
                                  style: Sty()
                                      .mediumBoldText
                                      .copyWith(color: Clr().primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//Api Method
  void verifyotp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Input
    FormData body = FormData.fromMap({
      'mobile': widget.sMobile,
      'page_type': 'register',
      'name': widget.sname,
      'email': widget.semail,
      'otp': otpCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().verifying, "verifyOtp", body);
    var error = result['success'];
    var message = result['message'];
    if (error) {
      setState(() {
        sp.setString('userid', result['user_id'].toString());
      });
      STM().finishAffinity(ctx, PersonalInfo());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void resendOTP(smobile) async {
    //Input
    FormData body = FormData.fromMap({
      'mobile': smobile,
      'page_type': widget.sType,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resendOtp", body);
    var error = result['success'];
    var message = result['message'];
    if (error) {
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void loginuser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Input
    FormData body = FormData.fromMap({
      'mobile': widget.sMobile,
      'page_type': 'login',
      'otp': otpCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().verifying, "verifyOtp", body);
    var error = result['success'];
    var message = result['message'];
    if (error) {
      setState(() {
        sp.setString('userid', result['user_id'].toString());
        result['slots'] == true ? sp.setBool('login', true) : null;
      });
      if(result['professional'] == false){
        result['personal'] == true ? result['education'] == true? STM().finishAffinity(ctx, ProfessionalInfo()) : STM().finishAffinity(ctx, EductaionalInfo()) : STM().finishAffinity(ctx, PersonalInfo());
      }else{
        result['professional'] == true ? result['slots'] == true ? STM().finishAffinity(ctx, Home()) : STM().finishAffinity(ctx, SlotSelection()) : STM().finishAffinity(ctx, ProfessionalInfo());
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

//
// _showSuccessDialog(ctx, message) {
//   AwesomeDialog(
//     context: ctx,
//     dialogType: DialogType.NO_HEADER,
//     animType: AnimType.BOTTOMSLIDE,
//     alignment: Alignment.centerLeft,
//     body: Container(
//       padding: EdgeInsets.symmetric(horizontal: Dim().d12),
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Error',
//             style: TextStyle(
//                 color: Clr().red, fontSize: 20, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(
//             height: Dim().d8,
//           ),
//           Text(
//             message,
//             style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
//           )
//         ],
//       ),
//     ),
//
//     // title: 'Error',
//     // titleTextStyle: TextStyle(color: Clr().red,
//     // fontSize: 20,
//     //   fontWeight: FontWeight.w600,
//     //
//     // ) ,
//     // desc: 'OTP चुकीचा आहे',
//     // descTextStyle: TextStyle(
//     //   fontSize: 16
//     // ),
//
//     btnOk: Padding(
//       padding: const EdgeInsets.only(left: 100),
//       child: ElevatedButton(
//         onPressed: () {
//           // STM().redirect2page(ctx, OTPVerificati);
//           Navigator.pop(context);
//         },
//         style: ElevatedButton.styleFrom(
//             backgroundColor: Clr().primaryColor,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5))),
//         child: Center(
//           child: Text(
//             'सुरू ठेवा',
//             style: Sty().mediumText.copyWith(
//                 color: Clr().white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400),
//           ),
//         ),
//       ),
//     ),
//   ).show();
// }
}
