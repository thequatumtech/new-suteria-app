import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/model_class/get_profile_model.dart';

Future<Map<String, String>> getHeader() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = (preferences.getString(tokenKey) ?? '');
  Map<String, String> header = <String, String>{
    'Authorization': 'Bearer $token'
  };
  return header;
}







GetProfileModel getProfileModelGlobal = GetProfileModel();

