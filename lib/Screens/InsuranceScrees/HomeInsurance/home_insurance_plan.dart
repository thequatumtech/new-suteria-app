import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class HomeInsurancePlanScreen extends StatefulWidget {
  const HomeInsurancePlanScreen({super.key});

  @override
  State<HomeInsurancePlanScreen> createState() => _HomeInsurancePlanScreenState();
}

class _HomeInsurancePlanScreenState extends State<HomeInsurancePlanScreen> {
  List names = [mobileno, email];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "$home  $insurance",
          size: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppText(
                text: beforeWeProceed,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextfield(width: 10, hint: fullname, lable: fullname),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextfield(width: 10, hint: nationality, lable: nationality),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextfield(width: 10, hint: national, lable: national),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextfield(width: 10, hint: limit, lable: limit),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextfield(width: 10, hint: appartment, lable: appartment),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextfield(width: 10, hint: apartmentsize, lable: apartmentsize),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextfield(width: 10, hint: detailedlocation, lable: detailedlocation),
            ),
            /*   InkWell(
              //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(nextImg)),
                  ),
                ),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppBtnWithColorShades(
                onTap: () {},
                btnTxt: next,
                color1: darkBlue2,
                color2: darkBlue1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
