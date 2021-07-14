import 'package:flutter/material.dart';
import 'package:product_approval_dashboard/page/product_approval.dart';

class RouteTo {
  // Root path
  static const String ROOT = "/";

  // Info pages
  static const String PRODUCT_APPROVAL = "/product/approval";

  var routes;
  RouteTo() {
    routes = {
      /// Info pages
      ROOT: (BuildContext context) => ProductApprovalPage(),
      PRODUCT_APPROVAL: (BuildContext context) => ProductApprovalPage()
    };
  }
}
