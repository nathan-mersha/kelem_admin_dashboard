import 'package:flutter/material.dart';

class Working extends StatelessWidget {
  const Working({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/working.png",
              height: 250,
            ),
            SizedBox(
              height: 10,
            ),
            // Text("Working on it", style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColor),),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                  onPressed: () {},
                  child: Text(
                    "working on it",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
