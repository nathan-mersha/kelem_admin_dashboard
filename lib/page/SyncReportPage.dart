import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:product_approval_dashboard/api/firebase_api.dart';

import 'package:product_approval_dashboard/model/sync_report.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:product_approval_dashboard/widget/stat_card.dart';

class SyncReportPage extends StatefulWidget {
  @override
  _SyncReportPageState createState() => _SyncReportPageState();
}

class _SyncReportPageState extends State<SyncReportPage> {
  bool busy = false;

  SyncShopsAPI syncShopsAPI = SyncShopsAPI();
  List<SyncReportModel> syncReportModels = [];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
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
                                title: "Syncs",
                                description: "Total created sync schedules",
                                stat: syncReportModels.length,
                                icon: Icon(Icons.all_inclusive, size: 25, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: StatCard(
                                title: "Created",
                                description: "One product was created",
                                stat: syncReportModels.where((SyncReportModel element) => element.created > 0).length,
                                icon: Icon(Icons.check, size: 25, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: StatCard(
                                title: "Removed",
                                description: "One product was removed",
                                stat: syncReportModels.where((SyncReportModel element) => element.removed > 0).length,
                                icon: Icon(Icons.clear, size: 25, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: StatCard(
                                title: "Updated",
                                description: "One product was updated",
                                stat: 0,
                                icon: Icon(Icons.update, size: 25, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: StatCard(
                                title: "Initiated manually",
                                description: "Sync was initiated manually",
                                stat: syncReportModels.where((SyncReportModel element) => element.initiated != "automatic").length,
                                icon: Icon(Icons.all_inclusive, size: 25, color: Theme.of(context).primaryColor),
                              ),
                            )
                          ],
                        )),
                  ],
                )),
              ),
              SizedBox(height: 10,),
              Expanded(
                  flex: 5,
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    child: buildSyncTable(),
                  ))
            ],
          ),
        )),
      ],
    );
  }

  void initializeData() async {
    List<SyncReportModel> data = await syncShopsAPI.getSync();

    setState(() {
      syncReportModels = data;
    });
  }

  Widget buildSyncTable() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(
                "Shops",
              ),
              margin: EdgeInsets.only(left: 20, top: 10),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: syncReportModels.length == 0
                    ? Loading()
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            dividerThickness: 0,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Shop',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Category',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Initiated',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text(
                                  'Created',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text(
                                  'Updated',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text(
                                  'Removed',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text(
                                  'Ignored',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text(
                                  'Total Analyzed',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Synced at',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            rows: syncReportModels
                                .map((SyncReportModel e) => DataRow(cells: [
                                      DataCell(
                                        Container(
                                          child: Text(
                                            e.shop["name"],
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: Text(
                                            e.shop["category"],
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: e.initiated == "automatic" ? Icon(Icons.query_builder, color: Theme.of(context).primaryColorLight,size: 15,) : Icon(Icons.handyman),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: Text(
                                            e.created.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: Text(
                                            e.updated.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: Text(
                                            e.removed.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: Text(
                                            e.ignored.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: Text(
                                            e.totalAnalyzed.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          child: Text(
                                            DateFormat.MMMMEEEEd().format(e.firstModified),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 13, color: Colors.black54),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ]))
                                .toList()),
                      ))
          ],
        ),
      ),
    );
  }
}
