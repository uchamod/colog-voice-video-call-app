import 'package:colog/constant/constants.dart';
import 'package:colog/routes/pageroutes/routes.dart';
import 'package:colog/services/user_services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final userId = pref.get(userIdKey) as String? ?? "";

  if (userId.isNotEmpty) {
    currentUser.id = userId;
    currentUser.name = pref.get(userNameKey) as String? ?? "";
  }

  //set navigator key
  //This allows direct access to navigation operations
  final navigatorKey = GlobalKey<NavigatorState>();
  //set navigator key to  ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  //Initializes ZegoUIKit’s logging system
  //Sets up the call invitation system to use the system’s native calling interface
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(
      navigatorKey: navigatorKey,
    ));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (currentUser.id.isNotEmpty) {
      onUserLogin();
    }
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Co-log",
      debugShowCheckedModeBanner: false,
      //set routes and initial route
      routes: routes,
      initialRoute:
          currentUser.id.isNotEmpty ? PageRoutes.home : PageRoutes.login,
      //set font style
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      //set navigator key
      navigatorKey: widget.navigatorKey,
      builder: (context, child) {
        return Stack(
          children: [
            child!,

            /// support minimizing
            ZegoUIKitPrebuiltCallMiniOverlayPage(
              contextQuery: () {
                //This is an anonymous function (a closure) that returns the BuildContext of the current state of the navigator.
                return widget.navigatorKey.currentState!.context;
              },
            ),
          ],
        );
      },
    );
  }
}
