 import 'package:flutter/material.dart';
import 'package:my_pet_opd/values/dimens.dart';

class ViewfullImage extends StatefulWidget {
  final String? url;
   const ViewfullImage({Key? key,this.url}) : super(key: key);

   @override
   State<ViewfullImage> createState() => _ViewfullImageState();
 }

 class _ViewfullImageState extends State<ViewfullImage> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(body: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Center(
           child: Container(
             width: Dim().d300,
             child: Image.network("${widget.url}",fit: BoxFit.cover,),
           ),
         ),
       ],
     ),);
   }
 }
