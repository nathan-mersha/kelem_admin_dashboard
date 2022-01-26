import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_approval_dashboard/route/route.dart';
import 'package:product_approval_dashboard/rsr/theme/main_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late SharedPreferences prefs;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    // todo : build command
    // C:\Users\nathan\Documents\Software\flutter_windows_2.8.1-stable\flutter\bin\flutter.bat build web --web-renderer html --release

    var routes = RouteTo().routes;

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text("Something went wrong"),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(debugShowCheckedModeBanner: false, theme: MainTheme.getTheme(), title: "Kelem Product Approval", routes: routes);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          child: Center(
            child: Text("loading"),
          ),
        );
      },
    );
  }
}
