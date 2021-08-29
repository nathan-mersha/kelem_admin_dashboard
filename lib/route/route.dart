import 'package:flutter/material.dart';
import 'package:product_approval_dashboard/db/k_shared_preference.dart';
import 'package:product_approval_dashboard/page/home.dart';
import 'package:product_approval_dashboard/page/login.dart';

class RouteTo {
  // Root path
  static const String ROOT = "/";

  // Info pages
  static const String HOME = "/home";
  static const String LOGIN = "/login";

  var routes;
  String userSignedInEmail = "";

  RouteTo() {
    routes = {
      /// Info pages
      ROOT: (BuildContext context) => FutureBuilder(
            builder: buildPage,
            future: checkUserStatus(),
          ),
      LOGIN: (BuildContext context) => LoginPage(),
      HOME: (BuildContext context) => FutureBuilder(
            builder: buildPage,
            future: checkUserStatus(),
          ),
    };
  }

  Widget buildPage(BuildContext context, AsyncSnapshot snapshot) {
    String signedInEmail = snapshot.data.toString();

    if (signedInEmail.isEmpty || signedInEmail == "null") {
      return LoginPage();
    } else if (LoginPage.kelemAdminEmailList.contains(signedInEmail)) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }

  Future<String> checkUserStatus() async {
    KSharedPreference kSharedPreference = GetKSPInstance.kSharedPreference;
    dynamic userEmail = await kSharedPreference.get(KSharedPreference.KEY_USER_EMAIL);

    return userEmail.toString();
  }
}
