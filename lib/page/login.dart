import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product_approval_dashboard/api/firebase_auth.dart';
import 'package:product_approval_dashboard/db/k_shared_preference.dart';
import 'package:product_approval_dashboard/route/route.dart';

class LoginPage extends StatefulWidget {
  static const List<String> kelemAdminEmailList = [
    "nathanmersha@gmail.com",
    "michaelandom03@gmail.com"
  ];

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String MESSAGE_TYPE_NOTIFICATION = "message notification";
  static const String MESSAGE_TYPE_ERROR = "message error";

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        scale: 2.5,
                      ),
                      Text(
                        "Kelem Admin Dashboard",
                        style: TextStyle(color: Colors.black38, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  TextButton(
                    child: _isSigningIn ? CircularProgressIndicator() : Image.asset("assets/images/google_signin_btn.png"),
                    onPressed: () {
                      onSignInWthGoogle();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSignInWthGoogle() async {
    KSharedPreference kSharedPreference = GetKSPInstance.kSharedPreference;

    setState(() {
      _isSigningIn = true;
    });

    User? user = await Authentication.signInWithGoogle(context: context);
    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      if (LoginPage.kelemAdminEmailList.contains(user.email)) {
        kSharedPreference.set(KSharedPreference.KEY_USER_ID, user.uid);
        kSharedPreference.set(KSharedPreference.KEY_USER_NAME, user.displayName);
        kSharedPreference.set(KSharedPreference.KEY_USER_EMAIL, user.email);
        kSharedPreference.set(KSharedPreference.KEY_USER_IMAGE_URL, user.photoURL);

        Navigator.of(context).pushNamed(RouteTo.HOME);
      } else {
        showToastNotification("${user.email} is not authorized", type: MESSAGE_TYPE_ERROR);
      }
    }
  }

  void showToastNotification(String message, {String type = MESSAGE_TYPE_NOTIFICATION}) {
    Color backgroundColor = type == MESSAGE_TYPE_NOTIFICATION ? Colors.green : Colors.red;
    String webBc = type == MESSAGE_TYPE_NOTIFICATION ? "#669900" : "#cc0000";
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: webBc);
  }
}
