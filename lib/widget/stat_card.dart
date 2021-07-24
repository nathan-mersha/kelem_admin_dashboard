import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String description;
  final num stat;
  final Icon icon;

  StatCard({this.title = "title", this.description = "description", this.stat = 0, this.icon = const Icon(Icons.tag)});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.black38, fontSize: 12),
                  ),
                  icon
                ],
              ),
              Text(stat.toString(), style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800)),
              Expanded(child: Container()),
              Text(
                description,
                style: TextStyle(color: Colors.black87, fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }
}
