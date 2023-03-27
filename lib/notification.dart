import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/values/colors.dart';
import 'package:my_pet_opd/values/dimens.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:my_pet_opd/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late BuildContext ctx;
  String? Userid;
  List<dynamic> notificationlist = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        notificationbar();
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
      onWillPop: ()async{
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
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
          'Notifications',
          style: Sty()
              .largeText
              .copyWith(color: Clr().accentColor, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              notificationlist.isEmpty  ? Container(
                height: MediaQuery.of(ctx).size.height/1.3,
                child: Center(
                  child: Text('No Notifications',style: Sty().mediumBoldText,),
                ),
              ) : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: notificationlist.length,
                itemBuilder: (context, index) {
                  return notificationlayout(
                      context, index, notificationlist);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationlayout(ctx, index, list) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dim().d20, vertical: Dim().d12),
      child: Container(
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
            color: Clr().white,
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 1, spreadRadius: 0.5)
            ],
            borderRadius: BorderRadius.circular(Dim().d12)),
        child: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${list[index]['title'].toString()}',
                overflow: TextOverflow.fade,
                style: Sty().mediumBoldText,
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Text('${list[index]['description'].toString()}',
                  overflow: TextOverflow.fade, style: Sty().mediumText),
              SizedBox(
                height: Dim().d12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${list[index]['date'].toString()}',
                      style: Sty().mediumText)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void notificationbar() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result = await STM().post(ctx, Str().loading, 'get_notifications', body);
    setState(() {
      notificationlist = result['notifications'];
      sp.setString('date', DateTime.now().toString());
    });
  }


}
