import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/shop.dart';

import 'package:product_approval_dashboard/model/sync_report.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:product_approval_dashboard/widget/stat_card.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool busy = false;
  bool loaded = false;
  FbShopAPI fbShopAPI = FbShopAPI();
  SyncServerAPI syncServerAPI = SyncServerAPI();

  late List<Shop> shopsData;
  late Map<String, dynamic> systemInfo;
  late List<Map<String, dynamic>> systemInfoDisk= [];

  // flutter build web --web-renderer html --release
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  TextStyle titleStyle() {
    return TextStyle(color: Colors.black87, fontSize: 16);
  }

  TextStyle valueStyle() {
    return TextStyle(color: Colors.black54);
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
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 2,
                          child: StatCard(
                            title: "Shops",
                            description: "Total registered shops",
                            stat: loaded ? shopsData.length : 0,
                            icon: Icon(Icons.store, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: StatCard(
                            title: "Products",
                            description: "Total products",
                            stat: loaded ? getTotalProductsCount() : 0,
                            icon: Icon(Icons.shop, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "Approved",
                            description: "total approved",
                            stat: loaded ? getTotalUnapprovedProductsCount() : 0,
                            icon: Icon(Icons.check_circle_sharp, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "Updated",
                            description: "total updated",
                            stat: loaded ? getTotalUpdatedProductsCount() : 0,
                            icon: Icon(Icons.timelapse, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "Deleted",
                            description: "total deleted",
                            stat: loaded ? getTotalDeletedProductsCount() : 0,
                            icon: Icon(Icons.delete_sweep, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "None Product",
                            description: "total none products",
                            stat: loaded ? getTotalNoneProductsCount() : 0,
                            icon: Icon(Icons.error, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        )
                      ],
                    )),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "system",
                                              style: titleStyle(),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              loaded ? systemInfo["system"]["system"] : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("node", style: titleStyle()),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              loaded ? systemInfo["system"]["nodeName"] : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("release", style: titleStyle()),
                                            Text(
                                              loaded ? systemInfo["system"]["release"] : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("physical core", style: titleStyle()),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              loaded ? systemInfo["cpu"]["physicalCores"].toString() : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("version", style: titleStyle()),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              loaded ? systemInfo["system"]["version"] : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("machine", style: titleStyle()),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              loaded ? systemInfo["system"]["machine"] : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("processor", style: titleStyle()),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              loaded ? systemInfo["system"]["processor"].toString() : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("total core", style: titleStyle()),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              loaded ? systemInfo["cpu"]["totalCores"].toString() : "-",
                                              style: valueStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "Ram",
                            description: "available ram",
                            statString: loaded ? "${systemInfo["memory"]["used"]} / ${systemInfo["memory"]["total"]}" : "0/0",
                            icon: Icon(Icons.memory, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "Cpu",
                            description: "cpu consumption",
                            statString: loaded ? "${systemInfo["cpu"]["usage"]}" : "0 %",
                            icon: Icon(Icons.speed, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "Storage",
                            description: "available storage",
                            statString: loaded ? "${systemInfo["disk"][0]["used"]} / ${systemInfo["disk"][0]["totalSize"]}" : "0/0",
                            icon: Icon(Icons.storage, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Expanded(
                          child: StatCard(
                            title: "Network",
                            description: "sent / received",
                            statString: loaded ? "${systemInfo["network"]["sent"]} / ${systemInfo["network"]["received"]}" : "0/0",
                            icon: Icon(Icons.network_check_sharp, size: 25, color: Theme.of(context).primaryColor),
                          ),
                        )
                      ],
                    )),
                  ],
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    child: buildTable(),
                  ))
            ],
          ),
        )),
      ],
    );
  }

  num getTotalProductsCount() {
    num count = 0;
    shopsData.forEach((Shop element) {
      count += element.totalProducts;
    });
    return count;
  }

  num getTotalUnapprovedProductsCount() {
    num count = 0;
    shopsData.forEach((Shop element) {
      count += element.totalApprovedProducts;
    });
    return count;
  }

  num getTotalUpdatedProductsCount() {
    num count = 0;
    shopsData.forEach((Shop element) {
      count += element.totalUpdates;
    });
    return count;
  }

  num getTotalDeletedProductsCount() {
    num count = 0;
    shopsData.forEach((Shop element) {
      count += element.totalDeletions;
    });
    return count;
  }

  num getTotalNoneProductsCount() {
    num count = 0;
    shopsData.forEach((Shop element) {
      count += element.totalNoneProducts;
    });
    return count;
  }

  void initializeData() async {
    List<Shop> shopsDataVal = await fbShopAPI.getShops();
    Map<String, dynamic> systemInfoVal = await syncServerAPI.getSystemStat();

    setState(() {
      shopsData = shopsDataVal;
      systemInfo = systemInfoVal;
      systemInfo["disk"].forEach((value) {
        systemInfoDisk.add(value);
      });
      loaded = true;
    });
  }

  Widget buildTable() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(child: buildShopInfoTable(),),
          ),
          // SizedBox(width: 20,),
          Expanded(child: buildSystemInfoTable()),
        ],
      ),
    );
  }

  Widget buildShopInfoTable() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Shops",
              style: TextStyle(fontSize: 15),
            ),
            margin: EdgeInsets.only(left: 30, top: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: loaded
                ?
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(scrollDirection: Axis.vertical,child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: DataTable(
                columnSpacing: 140,
                dividerThickness: 0,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'name',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'subscription',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'products',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'approved',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'updates',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'deletions',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
                rows: shopsData.map((Shop e) => DataRow(cells: [
                  DataCell(
                    Container(
                      // width: 100,
                      child: Text(
                        e.name,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      // width: 100,
                      child: Text(
                        e.category,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      // width: 100,
                      child: Text(
                        e.subscriptionPackage,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.totalProducts.toString(),
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  DataCell(
                    Container(
                      child: Text(
                        e.totalApprovedProducts.toString(),
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      child: Text(
                        e.totalUpdates.toString(),
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      child: Text(
                        e.totalDeletions.toString(),
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ]))
                    .toList()),),),)
                : Loading(),
          )
        ],
      ),
    );
  }

  Widget buildSystemInfoTable() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: loaded
                ?
                Container(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),child: SingleChildScrollView(scrollDirection: Axis.vertical,child: SingleChildScrollView(scrollDirection: Axis.horizontal,child:  DataTable(
                    dividerThickness: 0,
                                    columnSpacing: 45,

                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'device',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'total',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'used',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'perc',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                    rows: systemInfoDisk.map((Map<String, dynamic> e) =>  DataRow(cells: [
                      DataCell(
                        Container(
                          // width: 100,
                          child: Text(
                            e["device"],
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          e["totalSize"],
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      DataCell(
                        Container(
                          child: Text(
                            e["used"],
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          child: Text(
                            e["percentage"],
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ])).toList()),),),)
                : Loading(),
          )
        ],
      ),
    );
  }
}
