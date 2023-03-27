import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_profile.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'slot_selection.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class ProfessionalInfo extends StatefulWidget {
  final sType;

  const ProfessionalInfo({super.key, this.sType});

  @override
  State<ProfessionalInfo> createState() => _ProfessionalInfoState();
}

class _ProfessionalInfoState extends State<ProfessionalInfo> {
  late BuildContext ctx;
  TextEditingController experCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? Userid;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProfessional();
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
        widget.sType == 'profile'
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
              widget.sType == 'profile'
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
        widget.sType == 'profile'? Container() : Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: Text(
                widget.sType == 'profile' ? '' :  'Step 3 of 3',
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
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Professional Information',
                    style: Sty().largeText.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Clr().black,
                        fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                TextFormField(
                  controller: experCtrl,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Years of experience is required';
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
                    hintText: "Years of Experience*",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: Dim().d24,
                ),
                TextFormField(
                  controller: addressCtrl,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Clinic address is required';
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
                    hintText: "Add Clinic / Hospital Address*",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: Dim().d40,
                ),
                SizedBox(
                  height: Dim().d56,
                  width: Dim().d240,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          professionalinfo();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )),
                ),
                SizedBox(
                  height: Dim().d300,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void professionalinfo() async {
    FormData body = FormData.fromMap({
      'address': addressCtrl.text,
      'experience': experCtrl.text,
      'doctor_id': Userid,
    });
    var result =
        await STM().post(ctx, Str().processing, 'doctor_professional', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() async {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool('professionalinfo', true);
        widget.sType == 'profile'
            ? STM().back2Previous(ctx)
            : STM().replacePage(ctx, SlotSelection());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getProfessional() async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result =
        await STM().postWithoutDialog(ctx, 'get_doctor_professional', body);
    var success = result['success'];
    if (success) {
      setState(() {
        addressCtrl = TextEditingController(text: result['doctor']['address']);
        experCtrl = TextEditingController(text: result['doctor']['experience'].toString());
      });
    }
  }
}
