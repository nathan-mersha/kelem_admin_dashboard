import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String description;
  final num stat;
  final String statString;
  final Icon icon;

  StatCard({this.title = "title", this.description = "description", this.stat = 0, this.statString = "", this.icon = const Icon(Icons.tag)});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child:Text(
                      title,
                      style: TextStyle(color: Colors.black38),
                    )),
                    icon
                  ],
                ),
                FittedBox(fit: BoxFit.fitWidth,child: Text(statString.isEmpty ? stat.toString() : statString, style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800)),),
              ],),


              FittedBox(fit: BoxFit.fitWidth,child: Text(
                description,
                style: TextStyle(color: Colors.black87, fontSize: 13),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
