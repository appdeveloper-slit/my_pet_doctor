import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/log_in.dart';
import 'package:my_pet_opd/manage/static_method.dart';
import 'package:my_pet_opd/side_drawer.dart';
import 'package:my_pet_opd/values/colors.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:my_pet_opd/values/styles.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_profile.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'contact_us.dart';
import 'notification.dart';
import 'online_consultation.dart';
import 'opd_appointment.dart';
import 'values/dimens.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;
  String? sValue = 'Home';
  dynamic details;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List<dynamic> resultList = [];
  List<dynamic> imageList = [];
  String? Userid;
  String? sUUID;
  bool? notificationCount;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final status = await OneSignal.shared.getDeviceState();
    setState(() {
      Userid = sp.getString('userid');
      sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getHome(false);
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
    return DoubleBack(
      message: 'Please press back once again',
      child: Scaffold(
        key: scaffoldState,
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        backgroundColor: Clr().white,
        appBar: AppBar(
          toolbarHeight: Dim().d80,
          backgroundColor: Clr().white,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(Dim().d8),
            child: InkWell(
                onTap: () {
                  scaffoldState.currentState?.openDrawer();
                },
                child: SvgPicture.asset('assets/menu.svg')),
          ),
          centerTitle: true,
          title: SvgPicture.asset('assets/logo.svg', width: 155),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, const Notifications());
                      },
                      child: SvgPicture.asset('assets/bell.svg')),
                  notificationCount == true
                      ? Positioned(
                          top: 16,
                          right: 13,
                          child: Container(
                            height: Dim().d32,
                            width: Dim().d12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
        drawer: navbar(ctx, scaffoldState, details),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: details == null
              ? Container()
              : details['doctor'][0]['profile_status'] == "0"
                  ? underProfileLayout()
                  : details['doctor'][0]['profile_status'] == "2"
                      ? rejectUserLayout()
                      : Column(
                          children: [
                            details == null
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.all(Dim().d16),
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              '${details['doctor'][0]['personal']['profile_picture'].toString()}',
                                          fit: BoxFit.cover,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 75.0,
                                            height: 75.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Clr().lightGrey),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        // CircleAvatar(
                                        //   radius: 35,
                                        //   backgroundImage: NetworkImage(
                                        //     '${details['doctor'][0]['personal']['profile_picture'].toString()}',
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${details['doctor'][0]['name'].toString()}',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                          color: Clr()
                                                              .primaryDarkColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                              SizedBox(
                                                height: Dim().d8,
                                              ),
                                              details['doctor'][0]
                                                          ['education'] ==
                                                      null
                                                  ? Container()
                                                  : Text(
                                                      '${details['doctor'][0]['education']['speciality_id'].toString()}',
                                                      style: Sty()
                                                          .mediumText
                                                          .copyWith(
                                                              color:
                                                                  Clr().black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff79C7E4),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      topLeft: Radius.circular(50))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dim().d24,
                                        horizontal: Dim().d12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Card(
                                            elevation: 0.5,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dim().d24,
                                                  vertical: Dim().d12),
                                              child: Column(
                                                children: [
                                                  Text('My Patients',
                                                      style: Sty()
                                                          .mediumText
                                                          .copyWith(
                                                              color: Clr()
                                                                  .primaryDarkColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                      '${details['my_patient_count'].toString()}',
                                                      style: Sty()
                                                          .mediumText
                                                          .copyWith(
                                                            color: Clr()
                                                                .primaryColor,
                                                          )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 0.5,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dim().d24,
                                                vertical: Dim().d12),
                                            child: Column(
                                              children: [
                                                Text('Total Appts',
                                                    style: Sty()
                                                        .mediumText
                                                        .copyWith(
                                                            color: Clr()
                                                                .primaryDarkColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                    '${details['total_appointment_count'].toString()}',
                                                    style: Sty()
                                                        .mediumText
                                                        .copyWith(
                                                          color: Clr()
                                                              .primaryColor,
                                                        )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 0.8,
                                            blurRadius: 2,
                                            offset: Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                        color: Clr().white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(50),
                                            topLeft: Radius.circular(50))),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dim().d24,
                                            horizontal: Dim().d12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Dim().d8),
                                              child: Text(
                                                  "Today's Appointments",
                                                  style: Sty()
                                                      .largeText
                                                      .copyWith(
                                                          color: Clr().black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    spreadRadius: 0.8,
                                                    blurRadius: 6,
                                                    offset: Offset(0,
                                                        1), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  side: BorderSide(
                                                      color: Clr().borderColor),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Dim().d16,
                                                              vertical:
                                                                  Dim().d8),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/opd.svg'),
                                                          SizedBox(
                                                            width: 12,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'OPD Appointment',
                                                                  style: Sty()
                                                                      .mediumText
                                                                      .copyWith(
                                                                          color: Clr()
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                  'Today :- ${details['today_opd_count'].toString()}',
                                                                  style: Sty()
                                                                      .smallText
                                                                      .copyWith(
                                                                          color: Clr()
                                                                              .primaryDarkColor,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Dim().d16),
                                                      child: InkWell(
                                                          onTap: () {
                                                            STM().redirect2page(
                                                                ctx,
                                                                OPDAppointment());
                                                          },
                                                          child: SvgPicture.asset(
                                                              'assets/arrow.svg')),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    spreadRadius: 0.8,
                                                    blurRadius: 6,
                                                    offset: Offset(0,
                                                        1), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  side: BorderSide(
                                                      color: Clr().borderColor),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Dim().d16,
                                                              vertical:
                                                                  Dim().d8),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/video_cam.svg'),
                                                          SizedBox(
                                                            width: 12,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'Online Consultation',
                                                                  style: Sty()
                                                                      .mediumText
                                                                      .copyWith(
                                                                          color: Clr()
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                  'Today :- ${details['today_online_count'].toString()}',
                                                                  style: Sty()
                                                                      .smallText
                                                                      .copyWith(
                                                                          color: Clr()
                                                                              .primaryDarkColor,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        STM().redirect2page(ctx,
                                                            OnlineConsultant());
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    Dim().d16),
                                                        child: SvgPicture.asset(
                                                            'assets/arrow.svg'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(
                                            //       left: Dim().d8),
                                            //   child: Text('Policies',
                                            //       style: Sty()
                                            //           .largeText
                                            //           .copyWith(
                                            //               color: Clr().black,
                                            //               fontWeight:
                                            //                   FontWeight.w500)),
                                            // ),
                                            // SizedBox(
                                            //   height: 16,
                                            // ),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.spaceEvenly,
                                            //   children: [
                                            //     InkWell(
                                            //       onTap: () {
                                            //         STM().openWeb('https://mypetopd.com/privacy');
                                            //       },
                                            //       child: Container(
                                            //         width: 162,
                                            //         decoration: BoxDecoration(
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   12),
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //               color: Clr()
                                            //                   .lightGrey
                                            //                   .withOpacity(0.1),
                                            //               spreadRadius: 0.5,
                                            //               blurRadius: 6,
                                            //               offset: Offset(0,
                                            //                   1), // changes position of shadow
                                            //             ),
                                            //           ],
                                            //         ),
                                            //         child: Card(
                                            //           elevation: 0,
                                            //           shape:
                                            //               RoundedRectangleBorder(
                                            //             borderRadius:
                                            //                 BorderRadius
                                            //                     .circular(12),
                                            //             side: BorderSide(
                                            //                 color: Clr()
                                            //                     .borderColor),
                                            //           ),
                                            //           child: Padding(
                                            //             padding: EdgeInsets
                                            //                 .symmetric(
                                            //                     horizontal:
                                            //                         Dim().d12,
                                            //                     vertical:
                                            //                         Dim().d12),
                                            //             child: Row(
                                            //               children: [
                                            //                 SvgPicture.asset(
                                            //                     'assets/Group 35238.svg'),
                                            //                 SizedBox(
                                            //                   width: 6,
                                            //                 ),
                                            //                 Expanded(
                                            //                   child: Text(
                                            //                       'Privacy\nPolicy',
                                            //                       style: Sty()
                                            //                           .mediumText
                                            //                           .copyWith(
                                            //                               color: Clr()
                                            //                                   .black,
                                            //                               fontWeight:
                                            //                                   FontWeight.w400)),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     InkWell(onTap: (){
                                            //       STM().openWeb('https://mypetopd.com/terms');
                                            //     },
                                            //       child: Container(
                                            //         width: 162,
                                            //         decoration: BoxDecoration(
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   12),
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //               color: Clr()
                                            //                   .lightGrey
                                            //                   .withOpacity(0.1),
                                            //               spreadRadius: 0.5,
                                            //               blurRadius: 6,
                                            //               offset: Offset(0,
                                            //                   1), // changes position of shadow
                                            //             ),
                                            //           ],
                                            //         ),
                                            //         child: Card(
                                            //           elevation: 0,
                                            //           shape:
                                            //               RoundedRectangleBorder(
                                            //             borderRadius:
                                            //                 BorderRadius.circular(
                                            //                     12),
                                            //             side: BorderSide(
                                            //                 color: Clr()
                                            //                     .borderColor),
                                            //           ),
                                            //           child: Padding(
                                            //             padding:
                                            //                 EdgeInsets.symmetric(
                                            //                     horizontal:
                                            //                         Dim().d12,
                                            //                     vertical:
                                            //                         Dim().d12),
                                            //             child: Row(
                                            //               children: [
                                            //                 SvgPicture.asset(
                                            //                     'assets/terms.svg'),
                                            //                 SizedBox(
                                            //                   width: 6,
                                            //                 ),
                                            //                 Expanded(
                                            //                   child: Text(
                                            //                       'Terms &\nConditions',
                                            //                       style: Sty().mediumText.copyWith(
                                            //                           color: Clr()
                                            //                               .black,
                                            //                           fontWeight:
                                            //                               FontWeight
                                            //                                   .w400)),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: CarouselSlider(
                                                options: CarouselOptions(
                                                  height: Dim().d160,
                                                  aspectRatio: 16 / 9,
                                                  viewportFraction: 0.9,
                                                  autoPlay: true,
                                                  disableCenter: true,
                                                  // enableInfiniteScroll: true,
                                                  // autoPlay: true,
                                                ),
                                                items: imageList
                                                    .map((e) => Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      Dim().d8),
                                                          width: Dim().d350,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(Dim()
                                                                              .d8)),
                                                                  border: Border.all(
                                                                      color: Clr()
                                                                          .lightGrey),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        e['image_path']
                                                                            .toString()),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            resultList.length == 0
                                                ? Container()
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        left: Dim().d8),
                                                    child: Text(
                                                        'Received Request',
                                                        style: Sty()
                                                            .largeText
                                                            .copyWith(
                                                                color:
                                                                    Clr().black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                  ),
                                            resultList.length == 0
                                                ? Container()
                                                : SizedBox(
                                                    height: 16,
                                                  ),
                                            resultList.length == 0
                                                ? Container()
                                                : SizedBox(
                                                    height: 160,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          resultList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return requestList(ctx,
                                                            index, resultList);
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        )),
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

  //Request List
  Widget requestList(ctx, index, list) {
    return Container(
      margin: EdgeInsets.only(right: Dim().d8),
      width: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Clr().lightGrey.withOpacity(0.3),
            spreadRadius: 0.2,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
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
            padding: EdgeInsets.symmetric(
                horizontal: Dim().d20, vertical: Dim().d16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${list[index]['user']['name'].toString()}',
                    style: Sty().mediumText.copyWith(
                        color: Clr().black, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 12,
                ),
                Text('Mob: ${list[index]['user']['mobile'].toString()}',
                    style: Sty().smallText.copyWith(
                        color: Clr().shimmerColor,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 70,
                      child: ElevatedButton(
                          onPressed: () {
                            approveRequest(
                                id: list[index]['id'],
                                status: '1',
                                index: index);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Clr().green),
                          child: SvgPicture.asset('assets/tickmark.svg')),
                    ),
                    SizedBox(
                      height: 40,
                      width: 70,
                      child: ElevatedButton(
                          onPressed: () {
                            approveRequest(
                                id: list[index]['id'],
                                status: '2',
                                index: index);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Clr().red),
                          child: SvgPicture.asset('assets/cross.svg')),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                )
              ],
            )),
      ),
    );
  }

  Widget underProfileLayout() {
    return Container(
      height: MediaQuery.of(ctx).size.height / 1.5,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d32),
            child: Container(
                height: Dim().d52,
                decoration: BoxDecoration(
                  color: Color(0xff2BC999),
                  borderRadius: BorderRadius.circular(Dim().d4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    STM().svgimage({'url': 'assets/Icon.svg'}),
                    Flexible(
                        child: Text(
                      'Your Profile is under review',
                      style: Sty()
                          .mediumBoldText
                          .copyWith(color: Clr().white, fontSize: Dim().d20),
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                )),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Text(
              'Your profile is under review, our team will check the details submitted by you and may even contact you for any further information.',
              style: Sty().mediumText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Text(
              'Once approved, you can start adding patients & receive the Video Consultation & OPD appointments',
              style: Sty().mediumText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: Dim().d24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dim().d48,
            ),
            child: InkWell(
              onTap: () {
                STM().redirect2page(context, ContactUs());
              },
              child: Container(
                height: Dim().d64,
                decoration: BoxDecoration(
                  color: Color(0xff55B6E7),
                  borderRadius: BorderRadius.circular(Dim().d8),
                ),
                child: Center(
                  child: Text(
                    'Contact Us',
                    style: Sty().mediumBoldText.copyWith(
                          color: Clr().white,
                          fontSize: Dim().d20,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget rejectUserLayout() {
    return Container(
      height: MediaQuery.of(ctx).size.height / 1.5,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d32),
            child: Container(
                height: Dim().d52,
                decoration: BoxDecoration(
                  color: Color(0xffFF4040),
                  borderRadius: BorderRadius.circular(Dim().d4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    STM().svgimage({'url': 'assets/Icon.svg'}),
                    Flexible(
                        child: Text(
                      'Your Profile is Rejected',
                      style: Sty()
                          .mediumBoldText
                          .copyWith(color: Clr().white, fontSize: Dim().d20),
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                )),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Text(
              'Your profile has been rejected due to the following reason - ${details['doctor'][0]['remark']}',
              style: Sty().mediumText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Text(
              'You can modify your details from My Profile screen',
              style: Sty().mediumText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: Dim().d24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dim().d48,
            ),
            child: InkWell(
              onTap: () {
                STM().redirect2page(ctx, MyProfile());
              },
              child: Container(
                height: Dim().d64,
                decoration: BoxDecoration(
                  color: Color(0xff55B6E7),
                  borderRadius: BorderRadius.circular(Dim().d8),
                ),
                child: Center(
                  child: Text(
                    'Visit My Profile',
                    style: Sty().mediumBoldText.copyWith(
                          color: Clr().white,
                          fontSize: Dim().d20,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void approveRequest({id, status, index}) async {
    FormData body = FormData.fromMap({
      'status': status,
      'id': id,
    });
    var result = await STM().postWithoutDialog(ctx, 'approve_request', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
      setState(() {
        resultList.removeAt(index);
        getHome(true);
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getHome(b) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
      'uuid': sUUID,
      'date': sp.getString('date') ?? "0000-00-00 00:00:00",
    });
    var result = b
        ? await STM().postWithoutDialog(ctx, 'get_home_data', body)
        : await STM().post(ctx, Str().loading, 'get_home_data', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        details = result;
        imageList = result['slider'];
        notificationCount = result['count'];
        details['doctor'][0]['status'] == 0
            ? STM().finishAffinity(ctx, LogIn())
            : null;
        details['doctor'][0]['status'] == 0 ? sp.clear() : null;
        resultList = result['pending_request'];
        sp.setString(
            'userprofile', details['doctor'][0]['profile_status'].toString());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
