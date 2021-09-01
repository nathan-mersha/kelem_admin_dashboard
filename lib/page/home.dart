import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:product_approval_dashboard/db/k_shared_preference.dart';
import 'package:product_approval_dashboard/page/contact_us.dart';
import 'package:product_approval_dashboard/page/sync_report_page.dart';
import 'package:product_approval_dashboard/page/product_approval.dart';
import 'package:product_approval_dashboard/page/settings.dart';
import 'package:product_approval_dashboard/page/shop.dart';
import 'package:product_approval_dashboard/page/statistics.dart';
import 'package:product_approval_dashboard/page/user.dart';
import 'package:product_approval_dashboard/route/route.dart';

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
      NAME: "Dashboard", //
      ICON_DATA: Icons.stacked_line_chart,
      CHILD: StatisticsPage(),
    },
    {
      NAME: "Product",
      ICON_DATA: Icons.shopping_basket,
      CHILD: ProductApprovalPage(),
    },
    {
      NAME: "Shop",
      ICON_DATA: Icons.storefront,
      CHILD: ShopPage(),
    },
    {
      NAME: "Sync report",
      ICON_DATA: Icons.sync_sharp,
      CHILD: SyncReportPage(),
    },
    {
      NAME: "Messages",
      ICON_DATA: Icons.contactless_rounded,
      CHILD: ContactUsPage(),
    },
    {
      NAME: "User", // User
      ICON_DATA: Icons.account_circle_outlined,
      CHILD: UserPage(),
    },
    {
      NAME: "Settings",
      ICON_DATA: Icons.settings_outlined,
      CHILD: SettingsPage(),
    },
  ];

  int selectedMenuIndex = 1; // set to product approval page (default)
  late KSharedPreference kSharedPreference;
  String userName = "";
  String userImage = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  void getUserData() async {
    kSharedPreference = GetKSPInstance.kSharedPreference;
    userName = await kSharedPreference.get(KSharedPreference.KEY_USER_NAME);
    userImage = await kSharedPreference.get(KSharedPreference.KEY_USER_IMAGE_URL);
    userEmail = await kSharedPreference.get(KSharedPreference.KEY_USER_EMAIL);
  }

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
            )));
  }

  Widget setPage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Text(
                    menus[selectedMenuIndex][NAME],
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                  padding: EdgeInsets.only(left: 30, bottom: 20, top: 10)),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 16.0,
                    child: ClipRRect(
                      child: userImage.isEmpty
                          ? ClipRRect(child: Icon(Icons.account_circle))
                          : userEmail == "michaelandom03@gmail.com" ? Image.asset("assets/images/baby_miki.png", width: 80,) : Image.network(
                              userImage,
                              width: 80,
                            ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        onLogOut();
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ))
                ],
              )
            ],
          ),
          Expanded(
              child: Container(
            child: menus[selectedMenuIndex][CHILD],
          ))
        ],
      ),
    );
  }

  void onLogOut() async {
    await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Really want to Logout?"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              kSharedPreference.set(KSharedPreference.KEY_USER_ID, "");
                              kSharedPreference.set(KSharedPreference.KEY_USER_NAME, "");
                              kSharedPreference.set(KSharedPreference.KEY_USER_EMAIL, "");
                              kSharedPreference.set(KSharedPreference.KEY_USER_IMAGE_URL, "");

                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushNamed(RouteTo.LOGIN);
                            },
                            child: Text(
                              "logout",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xffe77681)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
