import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_constrint.dart';
import 'package:soperia_user/app_utils/demo_localization.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/splash_screen.dart';

void main() async {
  /*await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);*/
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  setup();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

/* static void setLocale(BuildContext context, Locale newLocale) {
     _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
     state!.setLocale(newLocale);
   }*/
}

class _MyAppState extends State<MyApp> {
  // Locale? _locale;

  /* setLocale(Locale locale) {
     setState(() {
       _locale = locale;
     });
   }

   @override
   void didChangeDependencies() {
     getLocale().then((locale) {
       setState(() {
         _locale = getLangFromCode(locale == "en" ? 'en' : 'ps');
         languageCode = locale;
         loadLangs();
       });
     });
     super.didChangeDependencies();
   }*/
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soteria',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),

      /*     locale: _locale,
       supportedLocales: const [Locale("en", "US"), Locale("ar", "ARE")],
       localizationsDelegates: const [
         DemoLocalization.delegate,
         GlobalMaterialLocalizations.delegate,
         GlobalWidgetsLocalizations.delegate,
         GlobalCupertinoLocalizations.delegate,
       ],*/

      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode && supportedLocale.countryCode == locale?.countryCode) {
            print(supportedLocale);
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      home: const SplashView(),
      // home: HomeInsurancePlanScreen(),
    );
  }
}
