import 'package:flutter/material.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/my_policies_screen.dart';
import 'package:soperia_user/Screens/Profile/profile_screen.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

import 'home_screen.dart';

class HomePageBottomNav extends StatefulWidget {
  @override
  _HomePageBottomNavState createState() => _HomePageBottomNavState();
}

class _HomePageBottomNavState extends State<HomePageBottomNav> {
  int bottomBarCurrentIndex = 0;
  int sliderCurrentIndex = 0;

  List<Widget> screens = [
    HomePage(),
    const MyPolicies(),
    const ProfileScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: deepBlue,
        currentIndex: bottomBarCurrentIndex.clamp(0, 2), // Clamp _currentIndex between 0 and 2
        onTap: (int index) {
          setState(() {
            screens[index];
            bottomBarCurrentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage(buttomhome)),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(
              AssetImage(buttom_list),
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage(buttom_profile)),
            /*  activeIcon: Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),))*/
          ),
        ],
      ),
      body: IndexedStack(
        index: bottomBarCurrentIndex,
        children: screens,
      ),
    );
  }

  sideCopyAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //backgroundColor: Colors.transparent,
            alignment: Alignment.bottomCenter,
            content: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              height: 150,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(data),
                    Text(data),
                    Text(data),
                  ],
                ),
              ),
            ),

            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.only(bottom: 65, right: 15, left: 15),
          );
        });
  }
}
