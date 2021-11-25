import 'dart:async';
import 'package:firebase/firebase.dart' as fb;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/contact_us.dart';

import 'package:product_approval_dashboard/model/shop.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:product_approval_dashboard/widget/stat_card.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  static const String MESSAGE_TYPE_NOTIFICATION = "message notification";
  static const String MESSAGE_TYPE_ERROR = "message error";
  TextEditingController _fromController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  FbContactUsAPI firebaseContactUsAPI = FbContactUsAPI();
  List<ContactUs> contactUsMessages = [];

  ContactUs selectedContactUs = ContactUs(firstModified: DateTime.now(),lastModified: DateTime.now());


  // flutter build web --web-renderer html --release
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: buildProductTable(),
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // stat
                          Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      title: "Messages",
                                      description: "selecting 50 items max",
                                      stat: contactUsMessages.length,
                                      icon: Icon(Icons.error_outline_rounded, size: 25, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: StatCard(
                                      title: "Resolved",
                                      description: "Resolved Messages",
                                      stat: contactUsMessages.where((element) => element.resolved == true).length,
                                      icon: Icon(Icons.check, size: 25, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: StatCard(
                                      title: "Un Resolved",
                                      description: "Un Resolved messages",
                                      stat: contactUsMessages.where((element) => element.resolved == false).length,
                                      icon: Icon(Icons.all_inclusive, size: 25, color: Theme.of(context).primaryColor),
                                    ),
                                  )
                                ],
                              )),

                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.only(top: 12),
                              child: buildContactUsDetail(),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            )),
      ],
    );
  }

  void initializeData() async {
    List<ContactUs> data = await firebaseContactUsAPI.getUnResolvedContactUsMessages();
    setState(() {
      contactUsMessages = data;
    });
  }

  void setDataToForm() {
    _fromController.text = selectedContactUs.from;
    _titleController.text = selectedContactUs.title;
    _bodyController.text = selectedContactUs.body;
  }

  Widget buildProductTable() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Messages",
              ),
              margin: EdgeInsets.only(left: 20, top: 10),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: contactUsMessages.length == 0
                    ? Center(child: Icon(Icons.filter_none, color: Theme.of(context).primaryColor,),)
                    : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:

                    DataTable(
                        dividerThickness: 0,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'From',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Title',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Body',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                        rows: contactUsMessages
                            .map((ContactUs e) => DataRow(cells: [
                          DataCell(
                            Container(
                              // width: 100,
                              child: Text(
                                e.from,
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                                maxLines: 1,
                              ),
                            ),
                            onTap: () {
                              onItemSelected(e);
                            },
                          ),
                          DataCell(
                              Text(
                                e.title,
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ), onTap: () {
                            onItemSelected(e);
                          }),
                          DataCell(
                              Container(
                                child: Text(
                                  e.body,
                                  style: TextStyle(fontSize: 13, color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ), onTap: () {
                            onItemSelected(e);
                          }),
                        ]))
                            .toList()),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void onItemSelected(ContactUs contactUs) {
    setState(() {
      selectedContactUs = contactUs;
      setDataToForm();
    });
  }

  Widget buildApprovedStat() {
    return Container(color: Colors.blue);
  }

  Widget buildTotalStat() {
    return Container(
      color: Colors.blue,
    );
  }

  Widget buildContactUsDetail() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Detail"),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(children: [

                      TextFormField(
                        style: TextStyle(fontSize: 14),
                        controller: _fromController,
                        enabled: false,
                        decoration: InputDecoration(hintText: "from", labelText: "from"),
                        // The validator receives the text that the user has entered.
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 14),
                        controller: _titleController,
                        decoration: InputDecoration(hintText: "title", labelText: "title"),
                        // The validator receives the text that the user has entered.
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 14),
                        minLines: 10,
                        maxLines: 10,
                        controller: _bodyController,
                        decoration: InputDecoration(hintText: "body", labelText: "body"),
                        // The validator receives the text that the user has entered.
                      ),
                    ],),
                  ),
                )),

            Container(
              // padding: EdgeInsets.only(top: 40),
              margin: EdgeInsets.only(left: 150, right: 150, top: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Color(0xffe77681)),
                        child: Text("cancel"),
                        onPressed: () {
                          onCancelContactUs();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Color(0xff9299cd)),
                        child: Text("resolve"),
                        onPressed: () {
                          onResolveContactUs();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



  void onCancelContactUs() async {
    clearFormData();
  }



  void onResolveContactUs() async {

    selectedContactUs.resolved = true;
    await firebaseContactUsAPI.updateContactUsMessages(selectedContactUs);
    contactUsMessages.remove(selectedContactUs);
    clearFormData();
    showToastNotification("Successfully resolved message");
    // todo : go to the next one
    // todo : set state here



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


  void clearFormData() {
    setState(() {

      _fromController.clear();
      _titleController.clear();
      _bodyController.clear();

      selectedContactUs = ContactUs(firstModified: DateTime.now(), lastModified: DateTime.now());
    });
  }






}
