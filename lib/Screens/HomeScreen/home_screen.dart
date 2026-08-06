import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/Screens/HomeScreen/home_controller.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/automotive_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_step.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/individual_family_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_personal_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Life%20Insurance/life_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Travel%20Insurance/travel_insurance_stepper.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomBarCurrentIndex = 0;
  int sliderCurrentIndex = 0;

  List<String> imageUrls = [
    slider,
    slider,
    slider,
    slider,
  ];
  List<String> texts = [
    familyMedical,
    individualMedical,
    life,
    home,
    personalAccident,
    travel,
    marine,
    automotive,
    office,
    critical,
    pet,
    dental,
  ];

  List homescreenmenu = [
    const IndividualFamilyInsuranceStep(),
    const IndividualPersonalInsuranceStep(),
    const LifeInsuranceStep(),
    const HomeInsuranceStep(),
    const PersonalInsuranceStep(),
    const TravelInsuranceStep(),
    const MarineInsuranceStep(),
    const AutomotiveInsuranceStep(),
    const OfficeInsuranceStep(),
    const CriticalInsuranceStep(),
    const PetInsuranceStep(),
    const DentalInsuranceStep(),
  ];

  List<String> menulogos = [
    ic_individual_medical,
    ic_individual_medical,
    ic_life_insurance,
    ic_homeinsurance,
    ic_Personal_accident_insurance,
    ic_travel_insurance,
    ic_marine_insurance,
    ic_automotive_insurance,
    ic_office,
    ic_critical_ness_insurance,
    ic_pet_insurance,
    ic_dental_insurance,
  ];

  bool isShoHome = true;

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    getPref();
    homeController.getProfile(context);
    super.initState();
  }

  Future<void> setPref(bool isFirst) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("iswelcomescreen", isFirst);
  }

  Future<void> getPref() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      isShoHome = pref.getBool('iswelcomescreen') ?? true;

      isShoHome ? sideCopyAlert() : null;
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: homeController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(splashImg))),
                              ),
                              const SizedBox(width: 10),
                              Text("$welcome, ${getProfileModelGlobal.data?.firstName ?? ""}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const Spacer(),
                              /*const Icon(Icons.notifications_none_outlined),*/
                              const SizedBox(width: 10),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(translate))),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 200, // Set a fixed height for the CarouselSlider
                          child: CarouselSlider.builder(
                            itemCount: imageUrls.length,
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                margin: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: AssetImage(imageUrls[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 150.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              viewportFraction: 1.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  sliderCurrentIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            imageUrls.length,
                            (index) => Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: sliderCurrentIndex == index ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppText(
                                text: buyInsurancePolicy,
                                fontWeight: FontWeight.bold,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(homescreenmenu.length, (index) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => homescreenmenu[index],
                                  )),
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: gold, width: 0.5),
                                    ),
                                    child: Center(
                                      child: menulogos[index].contains(".png") ? Image.asset(menulogos[index]) : SvgPicture.asset(menulogos[index]),
                                    ),
                                  ),
                                  AppText(text: texts[index], fontWeight: FontWeight.bold, size: 10),
                                  AppText(text: insurance, fontWeight: FontWeight.bold, size: 10)
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
          );
        }),
      ),
    );
  }

  sideCopyAlert() {
    int increment = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                alignment: Alignment.bottomCenter,
                content: SizedBox(
                  height: 200,
                  width: 500,
                  child: Column(
                    crossAxisAlignment: increment == 1
                        ? CrossAxisAlignment.start
                        : increment == 2
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2A8CC1), // #2A8CC1
                                Color(0xFF2255A4), // #2255A4
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    increment == 1
                                        ? welcomeHome
                                        : increment == 2
                                            ? manageYourPolicies
                                            : manageYourProfile,
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      await setPref(false);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 19,
                                      width: 19,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                      child: const Center(
                                          child: Icon(
                                        Icons.clear,
                                        size: 14,
                                      )),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  increment == 1
                                      ? getDailyUpdatesBuyNewInsurancePoliciesServicesFromSoteria
                                      : increment == 2
                                          ? getDailyUpdatesBuyNewInsurancePoliciesServicesFromSoteria
                                          : manageYourProfilePoliciesCheckRewardsGetConnectWithUs,
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    //backgroundColor:  Color(0xFF6E95C0),
                                    backgroundColor: increment == 1 ? Colors.white : const Color(0xFF6E95C0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: CircleAvatar(
                                      backgroundColor: increment == 2 ? Colors.white : const Color(0xFF6E95C0),
                                      radius: 5,
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: increment == 3 ? Colors.white : const Color(0xFF6E95C0),
                                    radius: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: CircleAvatar(
                                      backgroundColor: increment == 4 ? Colors.white : const Color(0xFF6E95C0),
                                      radius: 5,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: 34,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (increment == 4) {
                                            await setPref(false);
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              increment++;
                                            });
                                          }
                                        },
                                        child: Text(increment == 4 ? gotIt : next)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: increment == 1 ? 32 : 0, right: increment == 3 || increment == 4 ? 32 : 0),
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            color: const Color(0xff2569AF),
                            height: 10,
                            width: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.only(bottom: 14, right: 15, left: 15),
              );
            },
          );
        });
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
