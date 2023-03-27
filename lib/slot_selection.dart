import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:my_pet_opd/values/colors.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_home.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class SlotSelection extends StatefulWidget {
  final Stype;
  const SlotSelection({super.key, this.Stype});
  @override
  State<SlotSelection> createState() => _SlotSelectionState();
}

class _SlotSelectionState extends State<SlotSelection> {
  late BuildContext ctx;
  String? slotVale;
  List<dynamic> slotList = [];
  TextEditingController chargesCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String v = "0";
  String? dayValue;
  List<dynamic> dayList = [
    {"id": "1", "name": "Monday"},
    {"id": "2", "name": "Tuesday"},
    {"id": "3", "name": "Wednesday"},
    {"id": "4", "name": "Thursday"},
    {"id": "5", "name": "Friday"},
    {"id": "6", "name": "Saturday"},
    {"id": "7", "name": "Sunday"},
    {"id": "8", "name": "24/7"},
  ];
  String t = "0";
  bool slotcheck = false;
  List<TextEditingController> selectDayList = [TextEditingController()];
  String? Userid;
  var day;
  List<Map<String, dynamic>> daytimeList = [
    {
      'day': null,
      'slots': [],
    }
  ];
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getSlot();
        widget.Stype == 'profile' ? getslots() : null;
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
        widget.Stype == 'profile'? STM().back2Previous(ctx) :  SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              widget.Stype == 'profile'? STM().back2Previous(ctx) :   SystemNavigator.pop();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: SvgPicture.asset(
                'assets/back.svg',
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Slots Selection & Charges',
                  style: Sty().largeText.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Clr().black,
                      fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Video Consultation Charge (30 mins)',
                    // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                    style: Sty().smallText.copyWith(
                        fontWeight: FontWeight.w400, color: Clr().black)),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: chargesCtrl,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Consultation charge is required';
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
                    hintText: "₹",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                    'For OPD Consultation, you can decide & take your charges  directly from patient while they visit the clinic/ hospital',
                    // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                    style: Sty().smallText.copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        color: Clr().black)),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Select Days & Slots on which you’re available for Video / OPD Consultation. ',
                    // 'आम्ही तुम्हाला +91 ${widget.sMobile} वर पडताळणी कोड पाठवला आहे',
                    style: Sty().smallText.copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        color: Clr().black)),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daytimeList.length > 7 ? 7 : daytimeList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 0.8,
                                  blurRadius: 2,
                                  offset:
                                      Offset(0, 1), // changes position of shadow
                                ),
                              ],
                              color: Clr().formColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Clr().borderColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: daytimeList[index]['day'],
                              hint: Text(daytimeList[index]['day'] != null ? daytimeList[index]['day'] : 'Select Day',style: Sty().mediumText.copyWith(fontSize: Dim().d16, color: Clr().hintColor,),),
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 28,
                              ),
                              style: TextStyle(color: Color(0xff787882)),
                              onChanged: (t) {
                                // STM().redirect2page(ctx, Home());
                                if (daytimeList
                                    .map((e) => e['day'])
                                    .contains(t)) {
                                  STM().displayToast(
                                      "This day is already selected");
                                  print(daytimeList[index]['day']);
                                } else {
                                  setState(() {
                                    daytimeList[index]['day'] = t;
                                    day = t;
                                  });
                                }
                                setState(() {
                                  slotcheck = false;
                                });
                              },
                              items: dayList.map((string) {
                                return DropdownMenuItem(
                                  value: string['id'],
                                  child: Text(
                                    string['name'],
                                    style: TextStyle(
                                        color: Color(0xff787882), fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        daytimeList[index]['day'] == '8' ? Container() : InkWell(onTap:(){
                          showDialog(context: context, builder: (index2){
                            return MultiSelectDialog(
                              items: slotList.map((e) {
                                return MultiSelectItem(e['id'].toString(), e['slot'].toString());
                              }).toList(),
                              initialValue: daytimeList[index]['slots'] as List<dynamic>,
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
                                 daytimeList[index]['slots'] = results;
                                   slotcheck = false;
                               });
                               print(daytimeList);
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
                            child:Padding(
                              padding:  EdgeInsets.symmetric(horizontal: Dim().d14),
                              child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(daytimeList[index]['slots'].isNotEmpty ? 'Slots Selected' : 'Select Slots',style: Sty().mediumText.copyWith(color: const Color(0xff787882)),),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                      ],
                    );
                  },
                ),
                if (slotcheck)
                  Center(
                    child: Text(
                      "Please select day & slot",
                      style: Sty().microText.copyWith(color: Clr().errorRed),
                    ),
                  ),
                daytimeList.length == 7 ? Container() : daytimeList[0]['day'] == '8' ? Container() : Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: SvgPicture.asset(
                      "assets/plus.svg",
                    ),
                    onPressed: () {
                      setState(() {
                        daytimeList.add({
                          'day': null,
                          'slots':[],
                        });
                      });
                    },
                    label: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '+ Add more',
                        style: Sty()
                            .smallText
                            .copyWith(color: Clr().primaryDarkColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    height: 55,
                    width: 230,
                    child: ElevatedButton(
                        onPressed: () {
                          addslot();
                          // setState(() {
                          //   slotcheck = daytimeList.every(
                          //           (e) => e['day'] == null || e['slots'].isEmpty)
                          //       ? true
                          //       : false;
                          //   if (formKey.currentState!.validate()) {
                          //     STM().checkInternet(context, widget).then((value) {
                          //       if (value) {
                          //         if (daytimeList.every((e) => e['day'] != null && e['slots'].isNotEmpty)) {
                          //           addslot();
                          //         }else{
                          //           STM().displayToast('day or slots must be select');
                          //         }
                          //       }
                          //     });
                          //   }
                          // });
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getSlot() async {
    var result = await STM().getWithoutDialog(ctx, 'get_slots');
    var success = result['success'];
    if (success) {
      setState(() {
        slotList = result['slots'];
      });
    }
  }

  void getslots() async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result = await STM().postWithoutDialog(ctx, 'doctor_appointment_detail', body);
    var success = result['success'];
    var message = result['message'];
    if(success){
      setState(() {
        var form = result['doctorAppointmentDetails'];
        chargesCtrl = TextEditingController(text: form[0]['charge'].toString());
        var slot = form[0]['slots'];
        daytimeList.clear();
        for(var a in slot){
          daytimeList.add({
            'day': a['day'],
            'slots': a['slots'],
          });
        }
      });
    }else{
      STM().errorDialog(ctx, message);
    }
  }


 void addslot() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
    'charge': chargesCtrl.text,
    'doctor_id': Userid,
    'appointment_slots': jsonEncode(daytimeList)
    });
    var result = await STM().post(ctx, Str().processing, 'doctor_slot_detail', body);
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().displayToast(message);
      setState(() {
        sp.setBool('login', true);
        sp.setBool('slotselection', true);
        widget.Stype == 'profile'? STM().back2Previous(ctx) : STM().finishAffinity(ctx, Home());
      });
    }else{
      STM().errorDialog(ctx, message);
    }
 }

}
