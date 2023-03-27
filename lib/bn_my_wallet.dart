import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';


class MyWallet extends StatefulWidget {
  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  late BuildContext ctx;
  List<dynamic> resultList = [];
  dynamic amounthistory;
  String? Userid;
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getWalletHistory();
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
    return WillPopScope(onWillPop: ()async{
      STM().back2Previous(ctx);
      return false;
    },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 1),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leading: Padding(
            padding: EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                STM().back2Previous(ctx);
              },
              child: SvgPicture.asset(
                'assets/back.svg',
              ),
            ),
          ),
          title: Text(
            'Wallet History',
            style: Sty()
                .largeText
                .copyWith(color: Clr().accentColor, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: amounthistory == null ? Container() : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/wallet.svg'),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '₹ ${amounthistory['total_amount'].toString()}',
                    style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   width: 300,
              //   height: 50,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         // _addPatientDialog(ctx);
              //       },
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: Clr().primaryColor,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8))),
              //       child: Padding(
              //         padding: EdgeInsets.all(Dim().d12),
              //         child: Text(
              //           'Withdraw',
              //           style: TextStyle(
              //             fontWeight: FontWeight.w500,
              //             fontSize: 16,
              //           ),
              //         ),
              //       )),
              // ),
              // SizedBox(height: 12,),
              resultList.length == 0?  Container(
                height: MediaQuery.of(ctx).size.height/1.3,
                child: Center(
                  child: Text('No Transactions',style: Sty().mediumBoldText,),
                ),
              )  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                // itemCount: resultList.length,
                itemCount: resultList.length,
                itemBuilder: (context, index) {
                  return walletHistoryList(ctx, index, resultList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //history List
Widget walletHistoryList(ctx,index,list){
    return  Container(
      margin: EdgeInsets.only(bottom: 12),
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
        child: Column(
          children: [
            SizedBox(height: Dim().d12,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical:8 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Transaction ID',
                      style: Sty()
                          .smallText
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 16,),
                  Text(':'),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Text(
                      '543523',
                      style: Sty()
                          .smallText
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical:8 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Date',
                      style: Sty()
                          .smallText
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 16,),
                  Text(':'),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Text(
                      '07-11-2022',
                      style: Sty()
                          .smallText
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical:8 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                    list[index]['type'] == '1'? 'Credited' : 'Debited',
                      style: Sty()
                          .smallText
                          .copyWith(fontWeight: FontWeight.w500,
                          color: list[index]['type'] == '1'? Clr().green : Clr().red),
                    ),
                  ),
                  SizedBox(width: 16,),
                  Text(':'),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Text(
                      list[index]['type'] == '1'? '+ ${list[index]['amount'].toString()}' : '- ${list[index]['amount'].toString()}',
                      style: Sty()
                          .smallText
                          .copyWith(
                          color: list[index]['type'] == '1'? Clr().green : Clr().red,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dim().d12,),
          ],
        ),
      ),
    );
}

void getWalletHistory() async {
    FormData body = FormData.fromMap({
      'doctor_id': Userid,
    });
    var result = await STM().postWithoutDialog(ctx, 'get_wallet_history', body);
    var success = result['success'];
    var message = result['message'];
    if(success){
      setState(() {
        resultList = result['get_wallet'];
        amounthistory = result;
      });
    }else{
      STM().errorDialog(ctx, message);
    }
}

}
