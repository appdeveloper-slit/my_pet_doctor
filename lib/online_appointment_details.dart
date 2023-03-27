import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/bottom_navigation/bottom_navigation.dart';
import 'package:my_pet_opd/values/dimens.dart';
import 'package:my_pet_opd/viewfullimage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manage/static_method.dart';
import 'online_consultation.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'video_call/call.dart';

class OnlineConsultantDetails extends StatefulWidget {
  final details;
  const OnlineConsultantDetails({super.key, this.details});
  @override
  State<OnlineConsultantDetails> createState() => _OnlineConsultantDetailsState();
}

class _OnlineConsultantDetailsState extends State<OnlineConsultantDetails> {
  late BuildContext ctx;
  String? sID;

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("userid");
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(onWillPop: () async {
      STM().replacePage(ctx,OnlineConsultant());
      return false;
    },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              STM().replacePage(ctx,OnlineConsultant());
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: SvgPicture.asset(
                'assets/back.svg',
              ),
            ),
          ),
          title: Text(
            '${widget.details['user']['name'].toString()} (#${widget.details['appointment_id'].toString()})',
            style: Sty()
                .largeText
                .copyWith(color: Clr().accentColor, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Clr().lightGrey))),
            ),
            Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Clr().grey.withOpacity(0.1),
                          spreadRadius: 0.1,
                          blurRadius: 12,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Clr().borderColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            InkWell(onTap: (){
                              STM().redirect2page(ctx,ViewfullImage(url: widget.details['pet']['image_path'].toString(),) );
                            },child: Container(width: Dim().d100,height: Dim().d100,child: Image.network('${widget.details['pet']['image_path'].toString()}',fit: BoxFit.cover,),)),
                            SizedBox(
                              width: Dim().d20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.details['pet']['name'].toString()}',
                                  style: Sty().mediumText.copyWith(
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${widget.details['pet']['breed']['breed'].toString()}',
                                  style: Sty().smallText.copyWith(
                                    color: Clr().black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${widget.details['pet']['sex'].toString()}  Age : ${widget.details['pet']['age'].toString()}',
                                  style: Sty().smallText.copyWith(
                                    color: Clr().black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Clr().borderColor.withOpacity(0.1),
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/cal.svg'),
                                SizedBox(
                                  width: Dim().d12,
                                ),
                                Text(
                                  'Appointment Details',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          SizedBox(
                            height: Dim().d4,
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Date',
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(':'),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Text(
                                    '${widget.details['appointment_date']}',
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Time',
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(':'),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Text(
                                    '${widget.details['slot']['slot']}',
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Type',
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(':'),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.details['appointment_type'] == 1 ? 'OPD Appointment':'Video',
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  widget.details['status']== 1 ?  Container()  :  widget.details['status']== 2 ?  Container()  :  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (widget.details['appointment_type'] ==
                              1) {
                            status(
                              status: 1,
                              id: widget.details['id'].toString(),
                            );
                          } else {
                            await Permission.camera.request();
                            await Permission.microphone.request();
                            getToken();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Clr().green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: Text(
                            widget.details['appointment_type'] == 1 ? 'Mark as Complete' : 'Video Call',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  widget.details['status'] == 1 ?  Container()  :  widget.details['status'] == 2 ?  Container()  :   SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          widget.details['appointment_type'] == 1 ? status(status: 2,id: widget.details['id'].toString()) : status(status: 1,id: widget.details['id'].toString());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: widget.details['appointment_type'] == 1 ? Clr().red : Color(0xff79C7E4) ,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: Text(
                            widget.details['appointment_type'] == 1 ? 'Cancel Appointment' : 'Complete Appointment',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }


  void status({id,status}) async {
    FormData body = FormData.fromMap({
      'appointment_id': id,
      'type': status,
    });
    var result = await STM().postWithoutDialog(ctx, 'change_appointment_status', body);
    var success = result['success'];
    if(success){
      setState(() {
        widget.details['status'] = status;
      });
    }
  }

  //Api method
  void getToken() async {
    //Input
    FormData body = FormData.fromMap({
      'doctor_id': sID,
      'customer_id': widget.details['user_id'],
    });
    //Output
    var result =
    await STM().post(ctx, Str().loading, "agora/token", body);
    if (!mounted) return;
    var error = result['error'];
    if (!error) {
      Map<String, dynamic> map = {
        'id': sID,
        'name': widget.details['pet']['name'],
        'customer_id': widget.details['user_id'],
        'channel': result['channel'],
        'token': result['token'],
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(map),
        ),
      );
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

}
