import 'package:colog/pages/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../pages/login/loginpage.dart';

//navigatins for pages
class PageRoutes {
  static const String login = '/login';
  static const String home = '/home';
}

Map<String, WidgetBuilder> routes = {
  PageRoutes.login: (context) => const LoginPage(),
  PageRoutes.home: (context) =>
      const ZegoUIKitPrebuiltCallMiniPopScope(child: HomePage()),
};
