import 'dart:async';
import 'package:firebase/firebase.dart' as fb;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/global.dart';
import 'package:product_approval_dashboard/model/product.dart';
import 'package:product_approval_dashboard/model/shop.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:product_approval_dashboard/widget/stat_card.dart';

class ShopByUsersPage extends StatefulWidget {
  @override
  _ShopByUsersPageState createState() => _ShopByUsersPageState();
}

class _ShopByUsersPageState extends State<ShopByUsersPage> {
  final _formKey = GlobalKey<FormState>();
  static const String MODE_CREATE = "mode_create";
  static const String MODE_UPDATE = "mode_update";

  static const String MESSAGE_TYPE_NOTIFICATION = "message notification";
  static const String MESSAGE_TYPE_ERROR = "message error";

  bool busy = false;
  bool uploadingImage = false;
  String mode = MODE_CREATE;

  FbShopAPI firebaseAPI = FbShopAPI();
  FbProductAPI fbProductAPI = FbProductAPI();
  FbGlobalConfigAPI fbGlobalConfigAPI = FbGlobalConfigAPI();

  TextEditingController _nameController = TextEditingController(); // r
  TextEditingController _primaryPhoneController = TextEditingController(); // r
  TextEditingController _secondaryPhoneController = TextEditingController();

  TextEditingController _userIdController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _rankController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _physicalAddressController = TextEditingController();
  TextEditingController _coOrdinatesController = TextEditingController();

  List<Shop> shops = [];
  List<String> categories = [];
  List<String> subscriptionPackages = [];
  Shop selectedShop = Shop(firstModified: DateTime.now(), lastModified: DateTime.now());
  TsAPI tsAPI = TsAPI();


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
                                      title: "Shops",
                                      description: "All shops in database",
                                      stat: shops.length,
                                      icon: Icon(Icons.error_outline_rounded, size: 25, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: StatCard(
                                      title: "Verified",
                                      description: "Verified Shops",
                                      stat: shops.where((element) => element.isVerified == true).length,
                                      icon: Icon(Icons.check, size: 25, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: StatCard(
                                      title: "Un Verified",
                                      description: "Un Verified shops",
                                      stat: shops.where((element) => element.isVerified == false).length,
                                      icon: Icon(Icons.all_inclusive, size: 25, color: Theme.of(context).primaryColor),
                                    ),
                                  )
                                ],
                              )),

                          Expanded(
                            flex: 5,
                            child: Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: buildProductDetail()),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(flex: 1, child: buildProductImageView())
                                ],
                              ),
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
    List<Shop> data = await firebaseAPI.getShopsCreatedByUsers();
    List<String> categoriesData = [];
    List<String> subscriptionPackagesData = [];

    await fbGlobalConfigAPI.get().then((GlobalConfig value) {

      // extracting categories data
      List<Category> categoriesConfig = value.categories;

      categoriesConfig.forEach((Category element) {
        categoriesData.add(element.name);
      });

      categoriesData.add(Shop.UN_AVAILABLE);

      // extracting subscription package data
      List<SubscriptionPackage> subscriptionPackageConfig = value.subscriptionPackages;

      subscriptionPackageConfig.forEach((SubscriptionPackage element) {
        subscriptionPackagesData.add(element.name);
      });

      subscriptionPackagesData.add(Shop.UN_AVAILABLE);
    });



    setState(() {
      shops = data;
      categories = categoriesData;
      subscriptionPackages = subscriptionPackagesData;
    });
  }

  void setDetailData() {
    // todo : set the form on click here
    selectedShop.name = _nameController.text;
    selectedShop.primaryPhone = _primaryPhoneController.text;
    selectedShop.secondaryPhone = _secondaryPhoneController.text;

    selectedShop.userId = _userIdController.text;
    selectedShop.email = _emailController.text;
    selectedShop.rank = num.parse(_rankController.text);
    selectedShop.website = _websiteController.text;
    selectedShop.physicalAddress = _physicalAddressController.text;

    selectedShop.coOrdinates = _coOrdinatesController.text.split(",");
  }

  void setDataToForm() {
    _nameController.text = selectedShop.name;
    _primaryPhoneController.text = selectedShop.primaryPhone;
    _secondaryPhoneController.text = selectedShop.secondaryPhone;

    _userIdController.text = selectedShop.userId;
    _emailController.text = selectedShop.email;
    _rankController.text = selectedShop.rank.toString();
    _websiteController.text = selectedShop.website;
    _physicalAddressController.text = selectedShop.physicalAddress;
    _coOrdinatesController.text = selectedShop.coOrdinates.join(",");
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
                "Shops",
              ),
              margin: EdgeInsets.only(left: 20, top: 10),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: shops.length == 0
                    ? Loading()
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
                              'Ver',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
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
                              'Phone',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                        rows: shops
                            .map((Shop e) => DataRow(cells: [

                          DataCell(
                            Container(
                              // width: 100,
                              child: Icon(Icons.verified_rounded, color: e.isVerified ? Colors.green : Colors.black38,),
                            ),
                            onTap: () {
                              onItemSelected(e);
                            },
                          ),

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
                            onTap: () {
                              onItemSelected(e);
                            },
                          ),
                          DataCell(
                              Text(
                                e.category.toString(),
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ), onTap: () {
                            onItemSelected(e);
                          }),
                          DataCell(
                              Container(
                                child: Text(
                                  e.primaryPhone,
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

  void onItemSelected(Shop shop) {
    print("Shop selected ---- ");
    print(shop);
    setState(() {
      selectedShop = shop;
      setDataToForm();
      mode = MODE_UPDATE;
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

  Widget buildProductDetail() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Detail"),
                Row(
                  children: [
                    SelectableText(selectedShop.shopId == Shop.UN_AVAILABLE ? "" : selectedShop.shopId),
                    SizedBox(width: 10),
                    mode == MODE_UPDATE
                        ? AbsorbPointer(
                      absorbing: busy,
                      child: IconButton(
                          onPressed: () {
                            onDeleteShop(selectedShop);
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.redAccent,
                          )),
                    )
                        : Container()
                  ],
                )
              ],
            ),
            mode == MODE_UPDATE ? AbsorbPointer(absorbing: busy,child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                IconButton(
                    onPressed: () {
                      onDeleteProductsOfShop(selectedShop,Product.UN_APPROVED);
                    },
                    tooltip: "delete un-approved products",
                    icon: Icon(
                      Icons.auto_delete_outlined,
                      color: Colors.orange,
                    )),

                IconButton(
                    onPressed: () {
                      onDeleteProductsOfShop(selectedShop,Product.APPROVED);
                    },
                    tooltip: "delete approved products",
                    icon: Icon(
                        Icons.delete_sweep_outlined,
                        color: Color(0xff9299cd)
                    )),

                IconButton(
                    onPressed: () {
                      onDeleteProductsOfShop(selectedShop,Product.ALL);
                    },
                    tooltip: "delete all products",
                    icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xffe77681)
                    )),

              ],) ,): Container(),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          style: TextStyle(fontSize: 14),

                          controller: _nameController,

                          decoration: InputDecoration(hintText: "name", labelText: "name"),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 80,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "category",
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    DropdownButton<String>(
                                      items: categories.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      value: selectedShop.category,
                                      isExpanded: true,
                                      hint: Text(
                                        "categories",
                                        style: TextStyle(fontSize: 14, color: Colors.black54),
                                        textAlign: TextAlign.end,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedShop.category = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "subscription",
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    DropdownButton<String>(
                                      items: subscriptionPackages.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      value: selectedShop.subscriptionPackage,
                                      isExpanded: true,
                                      hint: Text(
                                        "subscription",
                                        style: TextStyle(fontSize: 14, color: Colors.black54),
                                        textAlign: TextAlign.end,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedShop.subscriptionPackage = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "is verified",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Switch(
                                  value: selectedShop.isVerified,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedShop.isVerified = value;
                                    });
                                  },
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Row(
                              children: [
                                Text(
                                  "is virtual",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Switch(
                                  value: selectedShop.isVirtual,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedShop.isVirtual = value;
                                    });
                                  },
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )
                          ],
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          controller: _primaryPhoneController,
                          decoration: InputDecoration(hintText: "primary phone", labelText: "primary phone"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter primary phone';
                            } else if (value.length < 10) {
                              return "Please enter valid phone number";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),

                          controller: _secondaryPhoneController,
                          decoration: InputDecoration(
                            hintText: "secondary phone",
                            labelText: "secondary phone",
                          ),
                          // The validator receives the text that the user has entered.
                        ),

                        TextFormField(
                          style: TextStyle(fontSize: 14),

                          controller: _userIdController,
                          decoration: InputDecoration(
                            hintText: "user id",
                            labelText: "user id",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter user id';
                            }
                            return null;
                          },
                          // The validator receives the text that the user has entered.
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          controller: _emailController,
                          decoration: InputDecoration(hintText: "email", labelText: "email"),
                          // The validator receives the text that the user has entered.
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          controller: _rankController,
                          validator: (value) {

                            num? parsedRank = num.tryParse(value!);

                            if (value.isEmpty) {
                              return 'Please enter rank value (lowest is 1)';
                            }else if (parsedRank == null) {
                              return "Rank must be a number (lowest is 1)";
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: "rank", labelText: "rank"),
                          // The validator receives the text that the user has entered.
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          controller: _websiteController,
                          decoration: InputDecoration(hintText: "website", labelText: "website"),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          controller: _physicalAddressController,
                          decoration: InputDecoration(hintText: "physical address", labelText: "physical address"),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          controller: _coOrdinatesController,
                          decoration: InputDecoration(hintText: "co-ordinates", labelText: "co-ordinates"),
                        ),


                      ],
                    ),
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
                      child: AbsorbPointer(
                        absorbing: busy,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Color(0xffe77681)),
                          child: Text("cancel"),
                          onPressed: () {
                            onCancelShop();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: AbsorbPointer(
                        absorbing: busy,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Color(0xff9299cd)),
                          child: Text(mode == MODE_CREATE ? "create" : "update"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (validateOtherData()) {
                                if (mode == MODE_CREATE) {
                                  onCreateShop();
                                } else {
                                  onUpdateShop();
                                }
                              }
                            }
                          },
                        ),
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

  bool validateOtherData() {
    if (selectedShop.category == Shop.UN_AVAILABLE) {
      showToastNotification("Shop Category is required", type: MESSAGE_TYPE_ERROR);
      return false;
    } else if (selectedShop.subscriptionPackage == Shop.UN_AVAILABLE) {
      showToastNotification("Shop subscription package is required", type: MESSAGE_TYPE_ERROR);
      return false;
    } else {
      return true;
    }
  }

  void onCancelShop() async {
    clearFormData();
  }

  void onDeleteShop(Shop shop) async {
    await showGeneralDialog(
        context: context,
        // context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Container(
                // width: MediaQuery.of(context).size.width - 10,
                // height: MediaQuery.of(context).size.height - 80,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Really want to delete : ${selectedShop.name}"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AbsorbPointer(
                          absorbing: busy,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        AbsorbPointer(
                          absorbing: busy,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  busy = true;
                                });
                                Navigator.of(context).pop();
                                await firebaseAPI.deleteShop(shop);
                                await fbProductAPI.deleteProductsOfShop(shop, Product.ALL);

                                clearFormData();
                                showToastNotification("Successfully deleted shop : ${shop.name} and related datas");
                                initializeData();

                                setState(() {
                                  busy = false;
                                });
                              },
                              child: Text(
                                "delete",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(primary: Color(0xffe77681))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void onDeleteProductsOfShop(Shop shop, String deleteType) async{

    await showGeneralDialog(
        context: context,
        // context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Container(
                // width: MediaQuery.of(context).size.width - 10,
                // height: MediaQuery.of(context).size.height - 80,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Really want to delete $deleteType products of shop ${shop.name}?"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AbsorbPointer(
                          absorbing: busy,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        AbsorbPointer(
                          absorbing: busy,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  busy = true;
                                });
                                Navigator.of(context).pop();
                                await fbProductAPI.deleteProductsOfShop(shop, deleteType);

                                // update shop status
                                if(deleteType == Product.ALL) {
                                  selectedShop.totalPosts = 0;
                                  selectedShop.totalDeletions = 0;
                                  selectedShop.totalUpdates = 0;
                                  selectedShop.totalApprovedProducts = 0;
                                  selectedShop.totalNoneProducts = 0;
                                  selectedShop.totalProducts = 0;
                                }else if(deleteType == Product.APPROVED){
                                  selectedShop.totalProducts = selectedShop.totalProducts - selectedShop.totalApprovedProducts;
                                  selectedShop.totalApprovedProducts = 0;
                                }

                                await firebaseAPI.updateShop(selectedShop);

                                // Updating shop

                                showToastNotification("Successfully deleted $deleteType products of shop ${shop.name}");
                                setState(() {
                                  busy = false;
                                });
                              },
                              child: Text(
                                "delete",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(primary: Color(0xffe77681))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });


  }

  void onUpdateShop() async {
    setState(() {
      busy = true;
    });
    setDetailData();
    await firebaseAPI.updateShop(selectedShop);
    await tsAPI.indexShop(selectedShop);
    clearFormData();

    showToastNotification("Successfully updated shop : ${selectedShop.name}");
    initializeData();


    setState(() {
      busy = false;
    });
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

  onCreateShop() async {
    setState(() {
      busy = true;
    });

    setDetailData();
    await firebaseAPI.createShop(selectedShop);
    await tsAPI.indexShop(selectedShop);
    clearFormData();
    showToastNotification("Successfully created shop");
    initializeData();

    setState(() {
      busy = false;
    });
  }

  void clearFormData() {
    setState(() {
      mode = MODE_CREATE;

      _nameController.clear();
      _primaryPhoneController.clear();
      _secondaryPhoneController.clear();
      _userIdController.clear();
      _emailController.clear();
      _rankController.clear();
      _websiteController.clear();
      _physicalAddressController.clear();
      _coOrdinatesController.clear();

      selectedShop = Shop(firstModified: DateTime.now(), lastModified: DateTime.now());
    });
  }

  Future<Uri?> imagePicker() {
    return ImagePickerWeb.getImageInfo.then((MediaInfo mediaInfo) {
      return uploadFile(mediaInfo, 'shops', mediaInfo.fileName ?? "");
    });
  }

  Future<Uri?> uploadFile(MediaInfo mediaInfo, String ref, String fileName) async {
    setState(() {
      uploadingImage = true;
    });
    try {
      String? mimeType = mime(p.basename(mediaInfo.fileName ?? ""));
      var metaData = fb.UploadMetadata(contentType: mimeType);
      fb.StorageReference storageReference = fb.storage().ref(ref).child(fileName);

      fb.UploadTaskSnapshot uploadTaskSnapshot = await storageReference.put(mediaInfo.data, metaData).future;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();


      setState(() {
        uploadingImage = false;
        selectedShop.logo = imageUri.toString();
      });

      return imageUri;
    } catch (e) {
      print('File Upload Error: $e');
      return null;
    }
  }

  Widget buildProductImageView() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: uploadingImage ? Loading() : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            selectedShop.logo == Shop.UN_AVAILABLE
                ? Image.asset(
              "assets/images/image_folder.png",
              width: 200,
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(selectedShop.logo),
            ),
            SizedBox(
              height: 30,
            ),
            OutlinedButton(
              onPressed: () async {
                await imagePicker();
              },
              child: Text("pick logo"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSideMenu() {
    return Container(
      padding: EdgeInsets.all(25),
      // color: Colors.black,
      color: Color(0xff5f5fd3),
      child: Column(
        children: [Image.asset("assets/images/logo.png")],
      ),
    );
  }
}
