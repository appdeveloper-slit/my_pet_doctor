import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/values/colors.dart';
import 'package:my_pet_opd/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/styles.dart';


class AppointmentHistory extends StatefulWidget {
  final ownerid,username;
  const AppointmentHistory({super.key, this.ownerid,this.username});
  @override
  State<AppointmentHistory> createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  late BuildContext ctx;
  List<dynamic> resultList = [];
  String? Userid;
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        appointmentHistory();
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

    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      backgroundColor: Clr().white,
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
          'Appointment History',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dim().d20,),
            resultList.length == 0 ? Container() : Text('${widget.username}',style: Sty().mediumBoldText,),
            SizedBox(height: Dim().d20,),
            resultList.length == 0 ? Container(height: MediaQuery.of(ctx).size.height/1.5,child: Center(child: Text('No Appointments History',style: Sty().mediumBoldText,),),) :ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              // itemCount: resultList.length,
              itemCount: resultList.length,
              itemBuilder: (context, index) {
                return appthistoryList(ctx, index, resultList);
              },
            ),
          ],
        ),
      ),
    );
  }

  //Appointment History
  Widget appthistoryList(ctx, index, list) {
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Name',
                          style: Sty().mediumText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(':'),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text('${list[index]['pet']['name'].toString()}',
                          style: Sty().smallText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Date',
                          style: Sty().mediumText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(':'),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text('${list[index]['appointment_date'].toString()}',
                          style: Sty().smallText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Time',
                          style: Sty().mediumText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(':'),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text('${list[index]['slot']['slot']}',
                          style: Sty().smallText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Type',
                          style: Sty().mediumText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(':'),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(list[index]['appointment_type'] == 1 ? 'OPD Appointment' : 'Video',
                          style: Sty().smallText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Status',
                          style: Sty().mediumText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(':'),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(list[index]['status'] == 0 ? 'Upcoming': list[index]['status'] == 1 ? 'Completed' : 'Cancelled',
                          style: Sty().smallText.copyWith(
                              color: list[index]['status'] == 0 ? Color(0xff55B6E7) : list[index]['status'] == 1 ? Clr().green : Clr().red, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void appointmentHistory() async {
    FormData body = FormData.fromMap({
      'user_id': widget.ownerid,
      'doctor_id': Userid,
    });
    var result = await STM().postWithoutDialog(ctx, 'appointment_history', body);
    var success = result['success'];
    var message = result['message'];
    if(success){
      setState(() {
        resultList = result['appointment_history'];
      });
    }else{
      STM().errorDialog(ctx, message);
    }
  }

}
