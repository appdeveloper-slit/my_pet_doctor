import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_pet_opd/personal_info.dart';
import 'package:my_pet_opd/professional_info.dart';
import 'package:my_pet_opd/slot_selection.dart';
import 'package:my_pet_opd/values/dimens.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bank_details.dart';
import 'bn_home.dart';
import 'bn_patient.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'educational_info.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late BuildContext ctx;
  final _formKey = GlobalKey<FormState>();
  bool again = false;
  String? Userid,
      profilebaselist,
      profile,
      name,
      dob,
      gender,
      sUserProfileStatus,
      mobile;
  File? imageFile;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
      sUserProfileStatus = sp.getString('userprofile');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getpersonalinfo();
      }
    });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        bottomNavigationBar: bottomBarLayout(ctx, 3),
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
            'My Profile',
            style: Sty()
                .largeText
                .copyWith(color: Clr().accentColor, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: Dim().d140,
                            width: Dim().d140,
                            decoration: BoxDecoration(
                              color: Clr().lightGrey,
                              border: Border.all(
                                color: Clr().grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dim().d100),
                              ),
                            ),
                            child:
                            ClipOval(
                              child: imageFile == null
                                  ? Image.network(
                                      '$profile',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 2,
                            child: InkWell(
                              onTap: () {
                                _getFromCamera();
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Clr().green,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset('assets/add.svg'),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '$name',
                      style: Sty().largeText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      '$mobile',
                      style: Sty().largeText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: Dim().d12,
                    ),
                    imageFile == null ? Container() : SizedBox(
                      width: Dim().d100,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              Clr().lightGrey,
                            ),
                            shape: MaterialStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                side: BorderSide(color: Clr().hintColor),
                              ),
                            ),
                          ),
                          onPressed: () {
                            personalInfo();
                          },
                          child: Center(
                            child: Text(
                              'Update',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().primaryColor),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx,
                            ProfessionalInfo(
                              sType: 'profile',
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().lightGrey.withOpacity(0.1),
                              spreadRadius: 0.6,
                              blurRadius: 12,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Clr().borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16, vertical: Dim().d20),
                                  child: Text(
                                    'Professional Information',
                                    style: Sty().mediumText.copyWith(),
                                  )),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d16),
                                child: InkWell(
                                    onTap: () {
                                      STM().redirect2page(
                                          ctx,
                                          ProfessionalInfo(
                                            sType: 'profile',
                                          ));
                                    },
                                    child: SvgPicture.asset('assets/arrow.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    sUserProfileStatus == '1'
                        ? Container()
                        : SizedBox(
                      height: 12,
                    ),
                    sUserProfileStatus == '1'
                        ? Container()
                        : InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx,
                            PersonalInfo(
                              Stype: 'profile',
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().lightGrey.withOpacity(0.1),
                              spreadRadius: 0.6,
                              blurRadius: 12,
                              offset: Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Clr().borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16,
                                      vertical: Dim().d20),
                                  child: Text(
                                    'Personal Information',
                                    style: Sty().mediumText.copyWith(),
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dim().d16),
                                child: InkWell(
                                    onTap: () {
                                      STM().redirect2page(
                                          ctx,
                                          PersonalInfo(
                                            Stype: 'profile',
                                          ));
                                    },
                                    child: SvgPicture.asset(
                                        'assets/arrow.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    sUserProfileStatus == '1'
                        ? Container()
                        : SizedBox(
                      height: 12,
                    ),
                    sUserProfileStatus == '1'
                        ? Container()
                        : InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx,
                            EductaionalInfo(
                              Stype: 'profile',
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().lightGrey.withOpacity(0.1),
                              spreadRadius: 0.6,
                              blurRadius: 12,
                              offset: Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Clr().borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16,
                                      vertical: Dim().d20),
                                  child: Text(
                                    'Educational Information',
                                    style: Sty().mediumText.copyWith(),
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dim().d16),
                                child: InkWell(
                                    onTap: () {
                                      STM().redirect2page(
                                          ctx,
                                          EductaionalInfo(
                                            Stype: 'profile',
                                          ));
                                    },
                                    child: SvgPicture.asset(
                                        'assets/arrow.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        updateMobileNumber();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().lightGrey.withOpacity(0.1),
                              spreadRadius: 0.6,
                              blurRadius: 12,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Clr().borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16, vertical: Dim().d20),
                                  child: Text(
                                    'Change Mobile Number',
                                    style: Sty().mediumText.copyWith(),
                                  )),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d16),
                                child: InkWell(
                                    onTap: () {
                                      updateMobileNumber();
                                    },
                                    child: SvgPicture.asset('assets/arrow.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, Patient());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().lightGrey.withOpacity(0.1),
                              spreadRadius: 0.6,
                              blurRadius: 12,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Clr().borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16, vertical: Dim().d20),
                                  child: Text(
                                    'My Patients',
                                    style: Sty().mediumText.copyWith(),
                                  )),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d16),
                                child: InkWell(
                                    onTap: () {
                                      STM().redirect2page(ctx, Patient());
                                    },
                                    child: SvgPicture.asset('assets/arrow.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d12,
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx,
                            SlotSelection(
                              Stype: 'profile',
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().lightGrey.withOpacity(0.1),
                              spreadRadius: 0.6,
                              blurRadius: 12,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Clr().borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16, vertical: Dim().d20),
                                  child: Text(
                                    'My Slots & Charges',
                                    style: Sty().mediumText.copyWith(),
                                  )),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d16),
                                child: InkWell(
                                    onTap: () {
                                      STM().redirect2page(
                                          ctx,
                                          SlotSelection(
                                            Stype: 'profile',
                                          ));
                                    },
                                    child: SvgPicture.asset('assets/arrow.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, BankDetails());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().lightGrey.withOpacity(0.1),
                              spreadRadius: 0.6,
                              blurRadius: 12,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Clr().borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16, vertical: Dim().d20),
                                  child: Text(
                                    'Bank Details',
                                    style: Sty().mediumText.copyWith(),
                                  )),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d16),
                                child: InkWell(
                                    onTap: () {
                                      STM().redirect2page(ctx, BankDetails());
                                    },
                                    child: SvgPicture.asset('assets/arrow.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            // _addPatientDialog(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Clr().primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: Text(
                              'Share Customer App ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 0.8,
                                blurRadius: 6,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 144,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences sp =
                                      await SharedPreferences.getInstance();
                                  sp.setBool('is_login', false);
                                  sp.clear();
                                  STM().finishAffinity(context, LogIn());
                                  // _addPatientDialog(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Clr().white,
                                    elevation: 0.6,
                                    side: BorderSide(color: Clr().borderColor),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8))),
                                child: Padding(
                                  padding: EdgeInsets.all(Dim().d12),
                                  child: Center(
                                    child: Text('Logout',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().red)),
                                  ),
                                )),
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.1),
                        //         spreadRadius: 0.8,
                        //         blurRadius: 6,
                        //         offset:
                        //             Offset(0, 1), // changes position of shadow
                        //       ),
                        //     ],
                        //   ),
                        //   child: SizedBox(
                        //     width: 144,
                        //     height: 40,
                        //     child: ElevatedButton(
                        //         onPressed: () {
                        //           // _addPatientDialog(ctx);
                        //         },
                        //         style: ElevatedButton.styleFrom(
                        //             elevation: 0.6,
                        //             backgroundColor: Clr().white,
                        //             side: BorderSide(color: Clr().borderColor),
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(8))),
                        //         child: Padding(
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: Dim().d12, horizontal: Dim().d4),
                        //           child: Text('Delete Account',
                        //               textAlign: TextAlign.center,
                        //               style: Sty()
                        //                   .smallText
                        //                   .copyWith(color: Clr().red)),
                        //         )),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        var image = imageFile!.readAsBytesSync();
        profilebaselist = base64Encode(image);
      });
    }
    // else {
    //   setState(() {
    //     profilebaselist = sProfileImage;
    //   });
    // }
    // print(profilebaselist);
  }

  //Update mobile pop up
  void updateMobileNumber() {
    bool otpsend = false;
    // var updateUserMobileNumberController;
    // updateUserMobileNumberController.text = "";
    // updateUserOtpController.text = "";
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          TextEditingController updateUserMobileNumberController =
              TextEditingController();
          TextEditingController updateUserOtpController =
              TextEditingController();
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text("Change Mobile Number",
                  style:
                      Sty().mediumBoldText.copyWith(color: Color(0xff2C2C2C))),
              content: SizedBox(
                height: 120,
                width: MediaQuery.of(ctx).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: !otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "New Mobile Number",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller:
                                        updateUserMobileNumberController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Mobile filed is required';
                                      }
                                      if (value.length != 10) {
                                        return 'Mobile digits must be 10';
                                      }
                                    },
                                    maxLength: 10,
                                    decoration: Sty()
                                        .TextFormFieldOutlineStyle
                                        .copyWith(
                                          counterText: "",
                                          hintText: "Enter Mobile Number",
                                          prefixIconConstraints: BoxConstraints(
                                              minWidth: 50, minHeight: 0),
                                          suffixIconConstraints: BoxConstraints(
                                              minWidth: 10, minHeight: 2),
                                          border: InputBorder.none,
                                          // prefixIcon: Icon(
                                          //   Icons.phone,
                                          //   size: iconSizeNormal(),
                                          //   color: primary(),
                                          // ),
                                        ),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "One Time Password",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TextFormField(
                                    controller: updateUserOtpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Enter OTP",
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 50, minHeight: 0),
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 10, minHeight: 2),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xff2C2C2C),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: Dim().d8,),
                                    Column(
                                      children: [
                                        Visibility(
                                          visible: !again,
                                          child: TweenAnimationBuilder<
                                                  Duration>(
                                              duration:
                                                  const Duration(seconds: 60),
                                              tween: Tween(
                                                  begin: const Duration(
                                                      seconds: 60),
                                                  end: Duration.zero),
                                              onEnd: () {
                                                // ignore: avoid_print
                                                // print('Timer ended');
                                                setState(() {
                                                  again = true;
                                                });
                                              },
                                              builder: (BuildContext context,
                                                  Duration value,
                                                  Widget? child) {
                                                final minutes = value.inMinutes;
                                                final seconds =
                                                    value.inSeconds % 60;
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    "Re-send code in $minutes:$seconds",
                                                    textAlign: TextAlign.center,
                                                    style: Sty().mediumText,
                                                  ),
                                                );
                                              }),
                                        ),
                                        // Visibility(
                                        //   visible: !isResend,
                                        //   child: Text("I didn't receive a code! ${(  sTime  )}",
                                        //       style: Sty().mediumText),
                                        // ),
                                        SizedBox(height: Dim().d8,),
                                        Visibility(
                                          visible: again,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                again = false;
                                              });
                                              resendOTP(
                                                  updateUserMobileNumberController
                                                      .text);
                                              // STM.checkInternet().then((value) {
                                              //   if (value) {
                                              //     sendOTP();
                                              //   } else {
                                              //     STM.internetAlert(ctx, widget);
                                              //   }
                                              // });
                                            },
                                            child: Text(
                                              'Resend OTP',
                                              style: Sty().mediumText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ]),
                ),
              ),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    Visibility(
                      visible: !otpsend,
                      child: Expanded(
                        child: InkWell(
                          onTap: () async {
                            // API UPDATE START
                            if (_formKey.currentState!.validate()) {
                              SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              FormData body = FormData.fromMap({
                                'page_type': 'change_mobile',
                                'mobile': updateUserMobileNumberController.text,
                              });
                              var result = await STM()
                                  .post(ctx, Str().sendingOtp, 'sendOtp', body);
                              var success = result['success'];
                              var message = result['message'];
                              if (success) {
                                setState(() {
                                  otpsend = true;
                                });
                              } else {
                                STM().errorDialog(context, message);
                              }
                            }
                            // API UPDATE END
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Clr().primaryColor,
                            ),
                            child: const Center(
                              child: Text(
                                "Send OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: otpsend,
                      child: Expanded(
                        child: InkWell(
                            onTap: () {
                              // API UPDATE START
                              setState(() async {
                                otpsend = true;
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                FormData body = FormData.fromMap({
                                  'otp': updateUserOtpController.text,
                                  'mobile':
                                      updateUserMobileNumberController.text,
                                  'user_id': Userid,
                                });
                                var result = await STM().post(
                                  ctx,
                                  Str().updating,
                                  'change_mobile',
                                  body,
                                );
                                var success = result['success'];
                                var message = result['message'];
                                if (success) {
                                  Navigator.pop(ctx);
                                } else {
                                  STM().errorDialog(context, message);
                                }
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Clr().primaryColor,
                                ),
                                child: const Center(
                                    child: Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                )))),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Clr().primaryColor,
                              ),
                              child: const Center(
                                  child: Text("Cancel",
                                      style: TextStyle(color: Colors.white))))),
                    ),
                  ],
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        });
  }

  void getpersonalinfo() async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result =
        await STM().postWithoutDialog(ctx, 'get_doctor_personal', body);
    var success = result['success'];
    if (success) {
      setState(() {
        profile = result['doctor']['profile_picture'];
        name = result['doctor']['doctor']['name'];
        mobile = result['doctor']['doctor']['mobile'];
        dob = result['doctor']['dob'];
        gender = result['doctor']['gender'];
      });
    }
  }

  void personalInfo() async {
    FormData body = FormData.fromMap({
      'dob': dob,
      'gender': gender,
      'doctor_id': Userid,
      'profile_picture': profilebaselist,
    });
    var result =
        await STM().post(ctx, Str().processing, 'doctor_personal', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(()  {
        STM().successDialogWithReplace(ctx, message, widget);
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void resendOTP(smobile) async {
    //Input
    FormData body = FormData.fromMap({
      'mobile': smobile,
      'page_type':'change_mobile',
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resendOtp", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
      // _showSuccessDialog(ctx,message);
    }
  }
}
