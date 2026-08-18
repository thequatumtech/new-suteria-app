import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:soperia_user/Screens/HomeScreen/home_controller.dart';
import 'package:soperia_user/model_class/get_banner_model.dart';
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
import 'package:soperia_user/app_utils/app_button.dart';
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
  final CarouselSliderController _bannerCarouselController = CarouselSliderController();
  Timer? _bannerAutoScrollTimer;
  String _selectedLanguage = 'en';

  void _startAutoScrollTimer(List<BannerData> banners) {
    _bannerAutoScrollTimer?.cancel();
    if (banners.length <= 1) return;

    if (sliderCurrentIndex < banners.length && banners[sliderCurrentIndex].isVideo) {
      // Do not auto-scroll while playing a video banner
      return;
    }

    _bannerAutoScrollTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && banners.length > 1) {
        _bannerCarouselController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        String tempSelected = _selectedLanguage;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: grayshad200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: skyBlueShade4,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.language_rounded, color: deepBluedark, size: 22),
                            ),
                            const SizedBox(width: 12),
                            AppText(
                              text: chooseYourLanguage,
                              size: 16,
                              fontWeight: FontWeight.bold,
                              txtColor: deepBluedark,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: grayshad400, size: 20),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // English Option
                    _buildLanguageItem(
                      title: 'English',
                      subtitle: 'English',
                      code: 'en',
                      isSelected: tempSelected == 'en',
                      onTap: () {
                        setSheetState(() {
                          tempSelected = 'en';
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Arabic Option
                    _buildLanguageItem(
                      title: 'العربية',
                      subtitle: 'Arabic',
                      code: 'ar',
                      isSelected: tempSelected == 'ar',
                      onTap: () {
                        setSheetState(() {
                          tempSelected = 'ar';
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Confirm Button
                    AppBtnWithColorShades(
                      onTap: () async {
                        setState(() {
                          _selectedLanguage = tempSelected;
                        });
                        try {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          await pref.setString('selected_language', tempSelected);
                        } catch (_) {}

                        if (!mounted) return;
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: AppText(
                              text: tempSelected == 'ar'
                                  ? 'Language selected: Arabic (العربية)'
                                  : 'Language selected: English',
                              txtColor: primaryWhite,
                              size: 13,
                            ),
                            backgroundColor: deepBluedark,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      btnTxt: ok,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageItem({
    required String title,
    required String subtitle,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? skyBlueShade4 : primaryWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? deepBluedark : skyBlueShade2,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? deepBluedark : skyBlueShade3,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                code.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? primaryWhite : deepBluedark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? deepBluedark : primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? deepBluedark.withOpacity(0.8) : grayshad400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? deepBluedark : Colors.transparent,
                border: Border.all(
                  color: isSelected ? deepBluedark : grayshad200,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: primaryWhite)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAutoScrollTimer?.cancel();
    super.dispose();
  }

  Future<void> _launchURL(String urlString) async {
    if (urlString.isEmpty) return;
    Uri uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
    homeController.getBanners(context);
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
                : Column(
                    children: [
                      // Fixed Top Header (Profile pic, Welcome note & Language translate button)
                      Padding(
                        padding: const EdgeInsets.only(top: 14, left: 20, right: 20, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: ((homeController.rxGetProfileModel.value.data?.profilePic ?? getProfileModelGlobal.data?.profilePic) != null &&
                                        (homeController.rxGetProfileModel.value.data?.profilePic ?? getProfileModelGlobal.data?.profilePic)!.isNotEmpty)
                                    ? CachedNetworkImage(
                                        height: 38,
                                        width: 38,
                                        imageUrl: "$imgBaseUrl/${homeController.rxGetProfileModel.value.data?.profilePic ?? getProfileModelGlobal.data?.profilePic}",
                                        placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                                        errorWidget: (context, url, error) => Image.asset(splashImg, height: 38, width: 38, fit: BoxFit.cover),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(splashImg, height: 38, width: 38, fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "$welcome, ${homeController.rxGetProfileModel.value.data?.firstName ?? getProfileModelGlobal.data?.firstName ?? ""}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              // onTap: () => _showLanguageBottomSheet(context),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: skyBlueShade4,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: skyBlueShade2, width: 0.8),
                                ),
                                child: Image.asset(
                                  translate,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Scrollable Home Content
                      Expanded(
                        child: RefreshIndicator(
                          color: deepBlue,
                          onRefresh: () => homeController.refreshHome(context),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Builder(
                          builder: (context) {
                            List<BannerData> banners = homeController.getBannerModel.value.data ?? [];
                            if (banners.isEmpty) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 200,
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
                                ],
                              );
                            }
                            if (_bannerAutoScrollTimer == null && banners.length > 1) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _startAutoScrollTimer(banners);
                              });
                            }
                            return Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: CarouselSlider.builder(
                                    controller: _bannerCarouselController,
                                    itemCount: banners.length,
                                    itemBuilder: (context, index, realIndex) {
                                      final banner = banners[index];
                                      final bool isCurrentPage = (sliderCurrentIndex == index);

                                      if (banner.isVideo && banner.image != null && banner.image!.isNotEmpty) {
                                        return VideoBannerWidget(
                                          videoUrl: banner.image!,
                                          isCurrentPage: isCurrentPage,
                                          onVideoCompleted: () {
                                            if (banners.length > 1) {
                                              _bannerCarouselController.nextPage(
                                                duration: const Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                            }
                                          },
                                          onTap: () {
                                            if (banner.redirectUrl != null && banner.redirectUrl!.isNotEmpty) {
                                              _launchURL(banner.redirectUrl!);
                                            }
                                          },
                                        );
                                      }

                                      return InkWell(
                                        onTap: () {
                                          if (banner.redirectUrl != null && banner.redirectUrl!.isNotEmpty) {
                                            _launchURL(banner.redirectUrl!);
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: banner.image ?? '',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Image.asset(slider, fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 150.0,
                                      enlargeCenterPage: true,
                                      autoPlay: false,
                                      aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: banners.length > 1,
                                      viewportFraction: 1.0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          sliderCurrentIndex = index;
                                        });
                                        _startAutoScrollTimer(banners);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    banners.length,
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
                              ],
                            );
                          },
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
                ),
              ),
            ],
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

class VideoBannerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isCurrentPage;
  final VoidCallback onVideoCompleted;
  final VoidCallback? onTap;

  const VideoBannerWidget({
    super.key,
    required this.videoUrl,
    required this.isCurrentPage,
    required this.onVideoCompleted,
    this.onTap,
  });

  @override
  State<VideoBannerWidget> createState() => _VideoBannerWidgetState();
}

class _VideoBannerWidgetState extends State<VideoBannerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isCompleted = false;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      print("Initializing video banner: ${widget.videoUrl}");
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller.initialize();
      _controller.setLooping(false);
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
      _controller.addListener(_videoListener);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        if (widget.isCurrentPage) {
          _controller.play();
        }
      }
    } catch (e, stack) {
      print("Error initializing video banner ($e): $stack");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _videoListener() {
    if (_isInitialized && !_isCompleted && _controller.value.isInitialized) {
      final position = _controller.value.position;
      final duration = _controller.value.duration;
      if (duration > Duration.zero && (position >= duration - const Duration(milliseconds: 300) || position == duration)) {
        _isCompleted = true;
        print("Video banner completed playing. Scrolling to next.");
        widget.onVideoCompleted();
      }
    }
  }

  @override
  void didUpdateWidget(covariant VideoBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isInitialized) {
      if (widget.isCurrentPage && !oldWidget.isCurrentPage) {
        _isCompleted = false;
        _controller.seekTo(Duration.zero);
        _controller.play();
      } else if (!widget.isCurrentPage && oldWidget.isCurrentPage) {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.black12,
          ),
          child: const Center(child: Icon(Icons.videocam_off, color: Colors.grey, size: 40)),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width > 0 ? _controller.value.size.width : 16,
                          height: _controller.value.size.height > 0 ? _controller.value.size.height : 9,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMuted = !_isMuted;
                            _controller.setVolume(_isMuted ? 0.0 : 1.0);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
