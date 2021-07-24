import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitSquareCircle(
          color: Theme.of(context).primaryColor,
          size: 40.0,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "loading",
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}
