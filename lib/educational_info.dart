import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_profile.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'professional_info.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class EductaionalInfo extends StatefulWidget {
  final Stype;

  const EductaionalInfo({super.key, this.Stype});

  @override
  State<EductaionalInfo> createState() => _EductaionalInfoState();
}

String? degreeValue;
List<dynamic> degreeList = [];
String s = "0";
String? specialityValue;
List<dynamic> specialityList = [];
String t = "0";
String? scertificate;

class _EductaionalInfoState extends State<EductaionalInfo> {
  late BuildContext ctx;
  TextEditingController degreeCtrl = TextEditingController();
  TextEditingController specilityCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController vciCtrl = TextEditingController();
  List<dynamic> selectedSpecilitiesList = [];
  var degreename;
  var speciality;
  String? Userid;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        widget.Stype == 'profile' ? getEducationalInfo() : null;
        getdegree();
        getspeciality();
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
            : SystemNavigator.pop();
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
                  : SystemNavigator.pop();
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
                widget.Stype == 'profile' ? '' : 'Step 2 of 3',
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
              children: [
                SizedBox(
                  height: Dim().d12,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Educational Information',
                    style: Sty().largeText.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Clr().black,
                        fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    value: degreeValue,
                    hint: Text('Degree*'),
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Degree is required';
                      }
                    },
                    decoration: Sty()
                        .TextFormFieldOutlineStyle
                        .copyWith(fillColor: Clr().lightGrey, filled: true),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 24,
                    ),
                    style: TextStyle(color: Color(0xff787882)),
                    items: degreeList.map((string) {
                      return DropdownMenuItem(
                        value: string['name'].toString(),
                        child: Text(
                          string['name'],
                          style:
                              TextStyle(color: Color(0xff787882), fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        degreeValue = v! as String;
                      });
                    },
                  ),
                ),
                degreeValue == 'Other'
                    ? SizedBox(
                        height: Dim().d24,
                      )
                    : Container(),
                degreeValue == 'Other'
                    ? TextFormField(
                        controller: degreeCtrl,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Degree is required';
                          }
                        },
                        decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                            hintText: 'Enter Your Degree',
                            hintStyle: Sty()
                                .mediumText
                                .copyWith(color: Clr().hintColor)),
                      )
                    : Container(),
                SizedBox(
                  height: Dim().d24,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (index2) {
                          return MultiSelectDialog(
                            items: specialityList.map((e) {
                              return MultiSelectItem(
                                  e['name'].toString(), e['name'].toString());
                            }).toList(),
                            initialValue: selectedSpecilitiesList,
                            height: 350,
                            width: 450,
                            title: Text(
                              "Select Slots",
                              style: Sty().mediumText.copyWith(
                                    fontSize: Dim().d14,
                                    color: Clr().hintColor,
                                  ),
                            ),
                            selectedColor: Clr().black,
                            onConfirm: (results) {
                              setState(() {
                                selectedSpecilitiesList = results;
                                bool select = selectedSpecilitiesList.contains('Other');
                                print(selectedSpecilitiesList);
                                select ? specialityValue = 'Other' : specilityCtrl.clear();
                              });
                            },
                          );
                        });
                  },
                  child: Container(
                    height: Dim().d52,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0.8,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: Clr().formColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Clr().borderColor)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            specialityList.isNotEmpty
                                ? 'Specialities Selected'
                                : 'Select Specialities',
                            style: Sty()
                                .mediumText
                                .copyWith(color: const Color(0xff787882)),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: Dim().d24,
                // ),
                // DropdownButtonHideUnderline(
                //   child: DropdownButtonFormField(
                //     value: specialityValue,
                //     hint: Text('Specialities*'),
                //     isExpanded: true,
                //     validator: (value) {
                //       if (value == null) {
                //         return 'Specialities is required';
                //       }
                //     },
                //     icon: Icon(
                //       Icons.keyboard_arrow_down,
                //       size: 24,
                //     ),
                //     decoration: Sty()
                //         .TextFormFieldOutlineStyle
                //         .copyWith(fillColor: Clr().lightGrey, filled: true),
                //     style: TextStyle(color: Color(0xff787882)),
                //     items: specialityList.map((string) {
                //       return DropdownMenuItem(
                //         value: string['name'].toString(),
                //         child: Text(
                //           string['name'],
                //           style:
                //               TextStyle(color: Color(0xff787882), fontSize: 14),
                //         ),
                //       );
                //     }).toList(),
                //     onChanged: (v) {
                //       // STM().redirect2page(ctx, Home());
                //       setState(() {
                //         specialityValue = v! as String;
                //       });
                //     },
                //   ),
                // ),
                selectedSpecilitiesList.contains('Other')
                    ? SizedBox(
                        height: Dim().d24,
                      )
                    : Container(),
                selectedSpecilitiesList.contains('Other')
                    ? TextFormField(
                        controller: specilityCtrl,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Specialities is required';
                          }
                        },
                        decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                            hintText: 'Enter Your Specialities',
                            hintStyle: Sty()
                                .mediumText
                                .copyWith(color: Clr().hintColor)),
                      )
                    : Container(),
                SizedBox(
                  height: Dim().d24,
                ),
                TextFormField(
                  controller: vciCtrl,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'VCI number is required';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Clr().lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Clr().borderColor, width: 0.1),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Clr().borderColor)),
                    focusColor: Clr().borderColor,
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText: "State VCI Number*",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    filePicker('certificate', false);
                  },
                  child: Container(
                    child: DottedBorder(
                      color: Clr().shimmerColor, //color of dotted/dash line
                      strokeWidth: 1, //thickness of dash/dots
                      dashPattern: [6, 4],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/upload.svg', width: 30),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              scertificate != null
                                  ? 'Image Selected'
                                  : 'Upload State VCI Registration \nCertificate*',
                              style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Clr().black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 55,
                  width: 230,
                  child: ElevatedButton(
                      onPressed: () {
                        // STM().redirect2page(ctx, ProfessionalInfo());
                        if (formKey.currentState!.validate() &&
                            scertificate != null) {
                          edutionalinfo();
                        } else {
                          STM().displayToast(
                              'VCI Registration Certificate is required');
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
                SizedBox(
                  height: 130,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void edutionalinfo() async {
    FormData body = FormData.fromMap({
      'degree_id': degreeValue == 'Other' ? degreeCtrl.text : degreeValue,
      'speciality': specilityCtrl.text.isNotEmpty ? jsonEncode([specilityCtrl.text]) : jsonEncode(selectedSpecilitiesList),
      'other': specilityCtrl.text.isNotEmpty ? 'Other' : null,
      'degree_certificate': scertificate,
      'vci_number': vciCtrl.text,
      'doctor_id': Userid,
    });
    var result =
        await STM().post(ctx, Str().processing, 'doctor_education', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool('educationalinfo', true);
        widget.Stype == 'profile'
            ? STM().replacePage(ctx, MyProfile())
            : STM().replacePage(ctx, ProfessionalInfo());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getEducationalInfo() async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result =
        await STM().postWithoutDialog(ctx, 'get_doctor_education', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        vciCtrl = TextEditingController(text: result['doctor']['vci_number']);
      });
      if (degreeList.map((e) => e['name']).contains(result['doctor']['degree_id'])) {
        setState(() {
          degreeValue = result['doctor']['degree_id'];
        });
      } else {
        setState(() {
          degreeValue = 'Other';
          degreeCtrl = TextEditingController(text: result['doctor']['degree_id']);
        });
      }
      if(result['doctor']['other_speciality'] == 1){
        specilityCtrl = TextEditingController(text: result['doctor']['speciality_id'][0]);
        selectedSpecilitiesList.add('Other');
      }else{
        selectedSpecilitiesList = result['doctor']['speciality_id'];
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getdegree() async {
    var result = await STM().getWithoutDialog(ctx, 'get_degree');
    var success = result['success'];
    if (success) {
      setState(() {
        degreeList = result['degree'];
      });
    }
  }

  void getspeciality() async {
    var result = await STM().getWithoutDialog(ctx, 'get_speciality');
    var success = result['success'];
    if (success) {
      setState(() {
        specialityList = result['speciality'];
      });
    }
  }

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
          case "certificate":
            scertificate = base64Encode(image);
            break;
        }
      });
    }
  }
}
