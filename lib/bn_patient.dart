import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointment_history.dart';
import 'bn_home.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class Patient extends StatefulWidget {
  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  late BuildContext ctx;
  List<dynamic> resultList = [];
  String? Userid;
  TextEditingController  mobileCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getpatientlist();
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
        bottomNavigationBar: bottomBarLayout(ctx, 2),
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
            'My Patient',
            style: Sty().largeText.copyWith(
                color: Clr().accentColor, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    _addPatientDialog(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Padding(
                    padding: EdgeInsets.all(Dim().d12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Add new patient',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              resultList.length == 0
                  ? Container(
                      height: MediaQuery.of(ctx).size.height / 1.3,
                      child: Center(
                          child: Text(
                        'No Patients',
                        style: Sty().mediumBoldText,
                      )),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: resultList.length,
                      itemBuilder: (context, index) {
                        return patientList(ctx, index, resultList);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  //Patient List
  Widget patientList(ctx, index, list) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Clr().lightGrey.withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 6,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: Clr().borderColor),
          ),
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${list[index]['user']['name'].toString()}',
                        style: Sty().mediumText.copyWith(
                            color: Clr().black, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Mobile No : ${list[index]['user']['mobile'].toString()}',
                        style: Sty().smallText.copyWith(
                            color: Clr().black, fontWeight: FontWeight.w400)),
                  ],
                ),
                InkWell(
                  onTap: () {
                    STM().redirect2page(ctx, AppointmentHistory(ownerid: list[index]['user']['id'].toString(),username: list[index]['user']['name'].toString(),));
                  },
                  child: Text('View More',
                      style: Sty().smallText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          )),
    );
  }

  _addPatientDialog(ctx) {
    AwesomeDialog(
      context: ctx,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      alignment: Alignment.centerLeft,
      isDense: true,
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(Dim().d4),
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Text('Send joining request ',
                  style: Sty().mediumText.copyWith(
                      color: Clr().black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: mobileCtrl,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'This field is required';
                    }if(value.length != 10){
                      return 'Mobile digits must be 10';
                    }
                  },
                  maxLength: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Clr().lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Clr().borderColor, width: 0.1),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Clr().borderColor)),
                    focusColor: Clr().borderColor,
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText: "Enter patient mobile number",
                    counterText: "",
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              SizedBox(
                height: 40,
                width: 130,
                child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        sendrequest(no: mobileCtrl.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )),
              ),
              SizedBox(
                height: Dim().d24,
              ),
            ],
          ),
        ),
      ),
    ).show();
  }

  void sendrequest({no}) async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
      'mobile':no,
      'send_by': 1,
    });
    var result = await STM().post(ctx, Str().processing,'send_request', body);
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().displayToast(message);
      Navigator.pop(ctx);
    }else{
      STM().displayToast(message);
    }
  }


  void getpatientlist() async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result = await STM().postWithoutDialog(ctx, 'my_patient', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        resultList = result['my_patients'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
