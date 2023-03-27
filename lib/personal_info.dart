import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_pet_opd/values/dimens.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:my_pet_opd/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'educational_info.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';

class PersonalInfo extends StatefulWidget {
  final Stype;

  const PersonalInfo({super.key, this.Stype});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

String? sexValue, profile;
List<String> sexList = [
  'Male',
  'Female',
];
String s = "0";

class _PersonalInfoState extends State<PersonalInfo> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  String? Userid, profilebaselist, sAdharBack, sAdharFront;
  File? imageFile;
  bool? sadharfront, sadharback;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        widget.Stype == 'profile' ? getPersonalInfo() : null;
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
        widget.Stype == 'profile'
            ? STM().back2Previous(ctx)
            :  SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              widget.Stype == 'profile'
                  ? STM().back2Previous(ctx)
                  :  SystemNavigator.pop();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: SvgPicture.asset(
                'assets/back.svg',
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: Text(
                widget.Stype == 'profile' ? '' : 'Step 1 of 3',
                style: Sty()
                    .mediumText
                    .copyWith(color: Clr().black, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dim().d12,
                ),
                STM().align(
                  Alignment.centerLeft,
                  Text(
                    'Personal Information',
                    style: Sty().largeText.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Clr().black,
                        fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageContainer(),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                genderDropdown(),
                SizedBox(
                  height: Dim().d24,
                ),
                dobTextyformfiled(),
                SizedBox(
                  height: Dim().d24,
                ),
                adharfrontImage(),
                sadharfront == false
                    ? SizedBox(
                        height: Dim().d4,
                      )
                    : Container(),
                sadharfront == false
                    ? Text(
                        'Aadhaar card front side required',
                        style: Sty().mediumText.copyWith(color: Clr().errorRed),
                      )
                    : Container(),
                SizedBox(
                  height: Dim().d24,
                ),
                adharbackImage(),
                sadharback == false
                    ? SizedBox(
                        height: Dim().d4,
                      )
                    : Container(),
                sadharback == false
                    ? Text(
                        'Aadhaar card back side required',
                        style: Sty().mediumText.copyWith(color: Clr().errorRed),
                      )
                    : Container(),
                SizedBox(
                  height: Dim().d40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Dim().d56,
                      width: Dim().d240,
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                sAdharFront != null &&
                                sAdharBack != null) {
                              personalInfo();
                            }else{
                              sAdharFront != null ?  Container() : STM().displayToast('Aadhaar card front side image required');
                              sAdharBack != null ?  Container() : STM().displayToast('Aadhaar card back side image required');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Clr().primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
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

  // Pick Image
  void filePicker(type, userWantsCamera) async {
    bool isCamera = userWantsCamera;
    FilePickerResult? result;
    ImagePicker _picker = ImagePicker();
    XFile? photo;
    if (isCamera == true) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg']);
    }
    final image;
    if (result != null || photo != null) {
      if (isCamera == true) {
        image = await photo!.readAsBytes();
      } else {
        image = File(result!.files.single.path.toString()).readAsBytesSync();
      }
      setState(() {
        switch (type) {
          case "adharfront":
            sAdharFront = base64Encode(image);
            break;
          case "adharback":
            sAdharBack = base64Encode(image);
            break;
        }
      });
    }
  }

  Widget imageContainer() {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: Dim().d120,
                width: Dim().d120,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: NetworkImage(
                  //     '$sProfileImage',
                  //   ),
                  //   fit: BoxFit.cover,
                  // ),
                  color: Clr().lightGrey,
                  border: Border.all(
                    color: Clr().grey,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dim().d100),
                  ),
                ),
                child: ClipOval(
                  child: imageFile == null
                      ? profile == null
                          ? null
                          : Image.network(
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
                      child: SvgPicture.asset('assets/camera.svg'),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget dobTextyformfiled() {
    return TextFormField(
      readOnly: true,
      onTap: () {
        datePicker();
      },
      controller: dobCtrl,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Pickup date is required';
        }
      },
      // controller: mobileCtrl,
      keyboardType: TextInputType.name,
      decoration: Sty().TextFormFieldOutlineStyle.copyWith(
            filled: true,
            prefixIcon: Icon(Icons.calendar_month),
            fillColor: Clr().lightGrey,
            // label: Text('Enter Your Number'),
            hintText: "Date of Birth*",
            counterText: "",
          ),
    );
  }

  Widget genderDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        value: sexValue,
        hint: Text('Gender*'),
        decoration: Sty().TextFormFieldOutlineStyle,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 24,
        ),
        style: TextStyle(color: Color(0xff787882)),
        validator: (value) {
          if (value == null) {
            return 'Gender is required';
          }
        },
        items: sexList.map((String string) {
          return DropdownMenuItem<String>(
            value: string,
            child: Text(
              string,
              style: TextStyle(color: Color(0xff787882), fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (v) {
          // STM().redirect2page(ctx, Home());
          setState(() {
            sexValue = v!;
          });
        },
      ),
    );
  }

  Widget adharfrontImage() {
    return InkWell(
      onTap: () {
        filePicker('adharfront', false);
      },
      child: Container(
        child: DottedBorder(
          color: Clr().shimmerColor, //color of dotted/dash line
          strokeWidth: 1, //thickness of dash/dots
          dashPattern: [6, 4],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset('assets/upload.svg', width: 30),
                SizedBox(
                  width: 12,
                ),
                Text(
                  sAdharFront != null
                      ? 'Image Selected'
                      : 'Aadhaar Card Front-side Upload*',
                  style: Sty().mediumText.copyWith(
                      fontWeight: FontWeight.w400, color: Clr().black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget adharbackImage() {
    return InkWell(
      onTap: () {
        filePicker('adharback', false);
      },
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 2),
        child: DottedBorder(
          color: Clr().shimmerColor, //color of dotted/dash line
          strokeWidth: 1, //thickness of dash/dots
          dashPattern: [6, 4],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/upload.svg',
                  width: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  sAdharBack != null
                      ? 'Image Selected'
                      : 'Aadhaar Card Back-side Upload*',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Sty().mediumText.copyWith(
                      fontWeight: FontWeight.w400, color: Clr().black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dobCtrl = TextEditingController(text: s);
      });
    }
  }

  // api post
  void personalInfo() async {
    FormData body = FormData.fromMap({
      'gender': sexValue,
      'dob': dobCtrl.text,
      'doctor_id': Userid,
      'aadhaar_front_card': sAdharFront,
      'aadhaar_back_card': sAdharBack,
      'profile_picture': profilebaselist,
    });
    var result =
        await STM().post(ctx, Str().processing, 'doctor_personal', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool('personalinfo', true);
          widget.Stype == 'profile'
              ? STM().back2Previous(ctx)
              : STM().replacePage(ctx, EductaionalInfo());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getPersonalInfo() async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result =
        await STM().postWithoutDialog(ctx, 'get_doctor_personal', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        sexValue = result['doctor']['gender'];
        dobCtrl = TextEditingController(text: result['doctor']['dob']);
        profile = result['doctor']['profile_picture'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
