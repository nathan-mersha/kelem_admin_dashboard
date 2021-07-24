import 'package:flutter/material.dart';
import 'package:product_approval_dashboard/page/home.dart';
import 'package:product_approval_dashboard/page/product_approval.dart';

class RouteTo {
  // Root path
  static const String ROOT = "/";

  // Info pages
  static const String HOME = "/home";
  static const String LOGIN = "/login";

  var routes;
  RouteTo() {
    routes = {
      /// Info pages
      ROOT: (BuildContext context) => HomePage(),
      LOGIN: (BuildContext context) => HomePage(),
      HOME: (BuildContext context) => HomePage(),
    };
  }
}
