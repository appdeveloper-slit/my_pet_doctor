import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/log_in.dart';

import 'manage/static_method.dart';
// import 'otp.dart';
import 'otp.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';


class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late BuildContext ctx;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                image: AssetImage('assets/register_screen.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Dim().d36,
                        ),
                        InkWell(
                            onTap: () {
                              STM().back2Previous(ctx);
                            },
                            child: SvgPicture.asset('assets/back.svg')),
                        SizedBox(
                          height: Dim().d32,
                        ),
                        Center(
                          child:
                          SvgPicture.asset('assets/logo.svg', width: 280),
                        ),
                        SizedBox(
                          height: Dim().d32,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hello! Register to get started',
                            style: Sty().largeText.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Clr().black,
                                fontSize: 30),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d24,
                        ),
                        TextFormField(
                          controller: nameCtrl,
                          keyboardType: TextInputType.text,
                          decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                            filled: true,
                            fillColor: Color(0xffF7F8F9),
                            // label: Text('Enter Your Number'),
                            hintText: "Name",
                            hintStyle: Sty().mediumText.copyWith(
                              color: Color(0xff8391A1),
                            ),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                          },
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                            filled: true,
                            fillColor: Color(0xffF7F8F9),
                            // label: Text('Enter Your Number'),
                            hintText: "Email",
                            hintStyle: Sty().mediumText.copyWith(
                              color: Color(0xff8391A1),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        TextFormField(
                          controller: mobileCtrl,
                          keyboardType: TextInputType.number,
                          decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                            filled: true,
                            fillColor: Color(0xffF7F8F9),
                            // label: Text('Enter Your Number'),
                            hintText: "Mobile Number",
                            hintStyle: Sty().mediumText.copyWith(
                              color: Color(0xff8391A1),
                            ),
                            counterText: "",
                          ),
                          maxLength: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                            if (value.length != 10) {
                              return 'Enter the 10 digits number';
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
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
                                    registeruser();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Clr().primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(Dim().d8))),
                                child: Center(
                                  child: Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      fontFamily: 'urban',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dim().d24,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              STM().redirect2page(ctx, LogIn());
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: Sty().smallText.copyWith(
                                    fontSize: 16,
                                    fontFamily: 'urban',
                                    fontWeight: FontWeight.w500,
                                    color: Clr().black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Login Now',
                                    style: Sty().smallText.copyWith(
                                        color: Clr().primaryDarkColor,
                                        fontFamily: 'urban',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  void registeruser() async {
    FormData body = FormData.fromMap({
      'mobile': mobileCtrl.text,
      'page_type': 'register',
    });
    var result = await STM().post(ctx, Str().sendingOtp, 'sendOtp', body);
    var error = result['success'];
    var message = result['message'];
    if (error) {
      STM().redirect2page(
        ctx,
        OTPVerification(
          sname: nameCtrl.text,
          semail: emailCtrl.text,
          sMobile: mobileCtrl.text,
          sType: 'register',
        ),
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}