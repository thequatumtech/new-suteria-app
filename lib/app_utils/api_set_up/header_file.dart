import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/model_class/get_profile_model.dart';

Future<Map<String, String>> getHeader() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = (preferences.getString(tokenKey) ?? '');
  String lang = preferences.getString('selected_language') ?? preferences.getString('LAGUAGE_CODE') ?? 'en';
  Map<String, String> header = <String, String>{
    'Authorization': 'Bearer $token',
    'Accept-Language': lang,
    'lang': lang,
    'Accept': 'application/json',
  };
  return header;
}







GetProfileModel getProfileModelGlobal = GetProfileModel();

