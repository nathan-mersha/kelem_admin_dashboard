import 'package:flutter/material.dart';
import 'package:product_approval_dashboard/page/product_approval.dart';
import 'package:product_approval_dashboard/page/settings.dart';
import 'package:product_approval_dashboard/page/shop.dart';
import 'package:product_approval_dashboard/page/statistics.dart';
import 'package:product_approval_dashboard/page/user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String KELEM_ICON = "assets/images/logo.png";

  // Defining keys
  static const String NAME = "NAME";
  static const String KEY = "KEY";
  static const String ICON_DATA = "ICON_DATA";
  static const String CHILD = "CHILD";

  List menus = [
    {},
    {
      NAME: "Product",
      ICON_DATA: Icons.tag,
      CHILD: ProductApprovalPage(),
    },
    {
      NAME: "Shop",
      ICON_DATA: Icons.shopping_basket_outlined,
      CHILD: ShopPage(),
    },
    {
      NAME: "User", // User
      ICON_DATA: Icons.account_circle_outlined,
      CHILD: UserPage(),
    },
    {
      NAME: "Statistics", //
      ICON_DATA: Icons.insert_chart_outlined,
      CHILD: StatisticsPage(),
    },
    {
      NAME: "Settings",
      ICON_DATA: Icons.settings_outlined,
      CHILD: SettingsPage(),
    },
  ];

  int selectedMenuIndex = 2; // set to product approval page (default)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black12.withOpacity(0.05),
          child: Row(
            children: [
              Expanded(flex: 1, child: buildSideMenu()),
              Expanded(flex: 25, child: setPage()),
            ],
          )),
    );
  }

  Widget setPage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                child: Text(
                  menus[selectedMenuIndex][NAME],
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w900, fontSize: 15),
                ),
                padding: EdgeInsets.only(left: 30, bottom: 20, top: 10)),
          ),
          Expanded(
              child: Container(
            child: menus[selectedMenuIndex][CHILD],
          ))
        ],
      ),
    );
  }

  Widget buildSideMenu() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: EdgeInsets.only(top: 25, bottom: 35, left: 15, right: 15),
              child: Image.asset(
                KELEM_ICON,
                width: 25,
              ),
            );
          } else {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: selectedMenuIndex == index ? Colors.white : Theme.of(context).primaryColor,
                  width: 2,
                  height: 60,
                ),
                Expanded(
                    child: Container(
                        color: selectedMenuIndex == index ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMenuIndex = index;
                            });
                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Icon(
                                menus[index][ICON_DATA],
                                color: Colors.white,
                                size: selectedMenuIndex == index ? 20 : 16,
                              ),
                            ),
                          ),
                        )))
              ],
            );
          }
        },
      ),
    );
  }
}
