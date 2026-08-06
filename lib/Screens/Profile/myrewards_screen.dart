import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class MyRewardsScreen extends StatefulWidget {
  final String title;

  const MyRewardsScreen({super.key,required this.title});

  @override
  State<MyRewardsScreen> createState() => _MyRewardsScreenState();
}

class _MyRewardsScreenState extends State<MyRewardsScreen> {
  List imgs=[
    liclogo,
    liclogo,
    liclogo,
    liclogo,
    liclogo,
    liclogo,
    liclogo,
    liclogo,
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text(widget.title), const Spacer(), const Icon(Icons.add)],
        ),
      ),
       body: SingleChildScrollView(
         child: Column(
           children: [
             ListView.builder(

           shrinkWrap: true,
               itemCount: imgs.length

               ,itemBuilder: (context, index) {
               return InkWell(
                 /*onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeInsurancePdf(screenTitle: widget.screenTitle),)),*/
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                   child: Container(

                     decoration: BoxDecoration(
                       border: Border.all(color: gold),
                       borderRadius: const BorderRadius.all(Radius.circular(10)),
                     ),
                     child: Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                           child: Column(
                             children: [
                               Container(
                                 width: 60,
                                 height: 60,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(50),
                                     image: const DecorationImage(image: AssetImage(liclogo))
                                 ),
                               ),
                               const SizedBox(height: 5,),
                               AppText(text: "LIC",size: 12,)
                             ],
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(bottom: 15 ,top: 8),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               AppText(text: "LIC Secure Home Plan",size: 15,fontWeight:  FontWeight.bold,),
                               AppText(text: "Unlimited offers for you and your family\n Unlimited offers for you",size: 10,txtColor: primaryGrey,),
                               const SizedBox(
                                 height: 5,
                               ),


                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               );
             },)
           ],
         ),
       )
    );
  }
}
