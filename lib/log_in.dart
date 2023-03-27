import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/register.dart';
import 'manage/static_method.dart';
import 'otp.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late BuildContext ctx;
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Dim().d100,
                    ),
                    Center(
                      child: SvgPicture.asset('assets/logo.svg', width: 280),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome back! Glad to\nsee you, Again!',
                        style: Sty().largeText.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'urban',
                            color: Clr().black,
                            fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: mobileCtrl,
                      keyboardType: TextInputType.number,
                      decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                        filled: true,
                        fillColor: Color(0xffF7F8F9),
                        hintText: "Enter your mobile number",
                        hintStyle: Sty().mediumText.copyWith(
                            color: Color(0xff8391A1),
                            fontFamily: 'urban',
                            fontWeight: FontWeight.w600),
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
                      height: 40,
                    ),
                    SizedBox(
                      height: Dim().d56,
                      width: Dim().d260,
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              loginuser();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Clr().primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dim().d8))),
                          child: Text(
                            'Send OTP',
                            style: TextStyle(
                              fontFamily: 'urban',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                STM().redirect2page(ctx, Register());
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Don’t have an account? ",
                                  style: Sty().smallText.copyWith(
                                      fontSize: 16,
                                      fontFamily: 'urban',
                                      fontWeight: FontWeight.w400,
                                      color: Clr().black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Register Now',
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
  void loginuser() async {
    FormData body = FormData.fromMap({
      'mobile': mobileCtrl.text,
      'page_type': 'login',
    });
    var result = await STM().post(ctx, Str().sendingOtp, 'sendOtp', body);
    var error = result['success'];
    var message = result['message'];
    if (error) {
      STM().redirect2page(
        ctx,
        OTPVerification(
          sname: '',
          semail: '',
          sMobile: mobileCtrl.text,
          sType: 'login',
        ),
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
