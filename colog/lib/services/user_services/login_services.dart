import 'package:colog/constant/constants.dart';
import 'package:colog/services/avatar_builder/avatar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

/// Logs in the user by storing the user ID in local storage and updating the
/// current user information.
Future<void> loginUser(String userId, String userName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString(userIdKey, userId);
  await pref.setString(userNameKey, userName);

  currentUser.id = userId;
  currentUser.name = userName;
}

/// Remove the stored user ID from local storage. This will cause the user to
/// be logged out of the app.
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(userIdKey);
}

/// Initialize the call invitation service after user login.

/// This function is called after the user has logged in and the current user
/// information has been updated. It initializes the call invitation service
/// with the necessary configuration.

Future<void> onUserLogin() async {
  await dotenv.load();
  final secretCode = dotenv.get("APPID");
  int appId = int.parse(secretCode);

  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: appId,
    appSign: dotenv.env["APPSINGIN"]!,
    userID: currentUser.id,
    userName: currentUser.name,
    plugins: [ZegoUIKitSignalingPlugin()],
    requireConfig: (ZegoCallInvitationData data) {
      final config = (data.invitees.length > 1)
          ? ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
          : ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
      config.avatarBuilder = customAvatarBuilder;
      config.topMenuBar.isVisible = true;
      config.topMenuBar.buttons
          .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
      config.topMenuBar.buttons
          .insert(1, ZegoCallMenuBarButtonName.soundEffectButton);
      return config;
    },
  );
}
