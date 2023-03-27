import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pet_opd/values/colors.dart';
import 'package:my_pet_opd/values/dimens.dart';
import 'package:my_pet_opd/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/styles.dart';


class BankDetails extends StatefulWidget {
  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  late BuildContext ctx;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController accnumberCtrl = TextEditingController();
  TextEditingController mobilenumberCtrl = TextEditingController();
  TextEditingController ifscCtrl = TextEditingController();
  TextEditingController branameCtrl = TextEditingController();
  TextEditingController holdernameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? Userid;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Userid = sp.getString('userid');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getbabkdetails();
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
    return  WillPopScope(
      onWillPop: ()async{
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
            'Add Bank Details',
            style: Sty()
                .largeText
                .copyWith(color: Clr().accentColor, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bank Name',
                    style: Sty().largeText.copyWith(
                      fontSize: 16,
                        color: Clr().black, fontWeight: FontWeight.w400)),
                SizedBox(height: 12,),
                TextFormField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                    fillColor: Clr().white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                      borderSide: BorderSide.none
                        ),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText:
                    "Enter Bank Name",
                    counterText: "",
                  ),
                ),
                SizedBox(height: 24,),
                Text('Account Number',
                    style: Sty().largeText.copyWith(
                        fontSize: 16,
                        color: Clr().black, fontWeight: FontWeight.w400)),
                SizedBox(height: 12,),
                TextFormField(
                  controller: accnumberCtrl,
                  maxLength: 18,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                    fillColor: Clr().white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                        borderSide: BorderSide.none
                    ),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText:
                    "Enter Account Number",
                    counterText: "",
                  ),
                ),
                SizedBox(height: 24,),
                Text('Linked Mobile Number',
                    style: Sty().largeText.copyWith(
                        fontSize: 16,
                        color: Clr().black, fontWeight: FontWeight.w400)),
                SizedBox(height: 12,),
                TextFormField(
                  controller: mobilenumberCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'This field is required';
                    }
                    if(value.length != 10){
                      return 'Mobile digits must be 10';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                    fillColor: Clr().white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                        borderSide: BorderSide.none
                    ),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText:
                    "Enter Linked Mobile Number",
                    counterText: "",
                  ),
                ),
                SizedBox(height: 24,),
                Text('IFSC Code',
                    style: Sty().largeText.copyWith(
                        fontSize: 16,
                        color: Clr().black, fontWeight: FontWeight.w400)),
                SizedBox(height: 12,),
                TextFormField(
                  controller: ifscCtrl,
                  keyboardType: TextInputType.text,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                    fillColor: Clr().white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText:
                    "Enter IFSC Code",
                    counterText: "",
                  ),
                ),
                SizedBox(height: 24,),
                Text('Branch Name',
                    style: Sty().largeText.copyWith(
                        fontSize: 16,
                        color: Clr().black, fontWeight: FontWeight.w400)),
                SizedBox(height: 12,),
                TextFormField(
                  controller: branameCtrl,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'This filed is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                    fillColor: Clr().white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                        borderSide: BorderSide.none
                    ),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText:
                    "Enter Branch Name",
                    counterText: "",
                  ),
                ),
                SizedBox(height: 24,),
                Text('Account Holder Name',
                    style: Sty().largeText.copyWith(
                        fontSize: 16,
                        color: Clr().black, fontWeight: FontWeight.w400)),
                SizedBox(height: 12,),
                TextFormField(
                  controller: holdernameCtrl,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'This filed is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                    fillColor: Clr().white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                        borderSide: BorderSide.none
                    ),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText:
                    "Enter Account Holder Name",
                    counterText: "",
                  ),
                ),
                SizedBox(height: Dim().d32,),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          // _addPatientDialog(ctx);
                          if(_formKey.currentState!.validate()){
                            addbank();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Clr().primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(height: Dim().d12,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addbank() async {
    FormData body = FormData.fromMap({
      'bank_name': nameCtrl.text,
      'account_number': accnumberCtrl.text,
      'mobile': mobilenumberCtrl.text,
      'ifsc': ifscCtrl.text,
      'branch_name': branameCtrl.text,
      'account_holder_name': holdernameCtrl.text,
      'doctor_id': Userid,
    });
    var result = await STM().post(ctx, Str().processing, 'doctor_bank', body);
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().displayToast(message);
      STM().back2Previous(ctx);
    }else{
      STM().errorDialog(ctx, message);
    }
  }

  void getbabkdetails() async {
     FormData body = FormData.fromMap({
       'doctor_id': Userid,
     });
     var result = await STM().postWithoutDialog(ctx, 'get_doctor_bank', body);
     var success = result['success'];
     var message = result['message'];
     if(success){
       setState(() {
         nameCtrl = TextEditingController(text: result['doctor']['bank_name']);
         accnumberCtrl = TextEditingController(text: result['doctor']['account_number']);
         mobilenumberCtrl = TextEditingController(text: result['doctor']['mobile']);
         ifscCtrl = TextEditingController(text: result['doctor']['ifsc']);
         branameCtrl = TextEditingController(text: result['doctor']['branch_name']);
         holdernameCtrl = TextEditingController(text: result['doctor']['account_holder_name']);
       });
     }else{
       STM().errorDialog(ctx, message);
     }
  }

}