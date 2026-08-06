import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/Screens/AuthScreen/select_language.dart';
import 'package:soperia_user/Screens/HomeScreen/home_screen_bottom.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'app_utils/app_string.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
 /* @override
  void initState() {
    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  const LoginView()), (route) => false);
    });
    super.initState();
  }
*/

   @override
  void initState() {
    Timer(const Duration(seconds: 3), () async {
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SelectLanguage()), (Route<dynamic> route) => false);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(tokenKey).toString();
      if (token != "null" && token.isNotEmpty) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  HomePageBottomNav()), (Route<dynamic> route) => false);
      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SelectLanguage()), (Route<dynamic> route) => false);
      }
    });
    super.initState();
  }

 /* void setLogin() {
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String mobile = SharedPreferencesService(preferences).getString('mobile').toString();

      print('asdfddasdasdsaddasdasd $mobile');
      if (mobile == '' || mobile == 'null'|| mobile.isEmpty) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DashboardView()), (route) => false);
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage(splashImg)),
            const SizedBox(height: 15,),
            AppText(text:sos,txtColor:deepBlue,fontWeight: FontWeight.bold,size: 18,),
            AppText(text:sis,txtColor: deepBlue,fontWeight: FontWeight.bold,size: 22,)
          ],
        ),
      ),
    );
  }
}
