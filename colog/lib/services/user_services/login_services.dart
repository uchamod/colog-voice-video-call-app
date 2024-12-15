import 'package:colog/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//sing up new user
Future<void> loginUser(String userId, String userName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString(userIdKey, userId);

  currentUser.id = userId;
  currentUser.name = userName;
}
//logout user

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(userIdKey);
}
