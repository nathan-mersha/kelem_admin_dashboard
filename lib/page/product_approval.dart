import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/product.dart';
import 'package:product_approval_dashboard/model/shop.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:product_approval_dashboard/widget/no_data.dart';
import 'package:product_approval_dashboard/widget/stat_card.dart';

class ProductApprovalPage extends StatefulWidget {
  @override
  _ProductApprovalPageState createState() => _ProductApprovalPageState();
}

class _ProductApprovalPageState extends State<ProductApprovalPage> {
  final _formKey = GlobalKey<FormState>();

  FbProductAPI firebaseAPI = FbProductAPI();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _regularPriceController = TextEditingController();
  TextEditingController _authorController = TextEditingController();

  TextEditingController _subCategoryController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  TextEditingController _tagController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<Product> unApprovedProducts = [];
  bool dataInitialized = false;
  Product selectedProduct = Product(shop: Shop(firstModified: DateTime.now(), lastModified: DateTime.now()), firstModified: DateTime.now(), lastModified: DateTime.now());

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
                                  title: "Un Approved",
                                  description: "pending approval items",
                                  stat: unApprovedProducts.length,
                                  icon: Icon(Icons.error_outline_rounded, size: 25, color: Theme.of(context).primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: StatCard(
                                  title: "Approved",
                                  description: "total approved products",
                                  stat: 0,
                                  icon: Icon(Icons.check, size: 25, color: Theme.of(context).primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: StatCard(
                                  title: "Total",
                                  description: "total item in database",
                                  stat: 0,
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
    setState(() {
      dataInitialized = false;
    });
    List<Product> data = await firebaseAPI.getUnApprovedProducts();
    setState(() {
      unApprovedProducts = data;
      selectedProduct = unApprovedProducts.first;
      setDetailData();
      dataInitialized = true;
    });
  }

  void setDetailData() {
    _nameController.text = selectedProduct.name;
    _priceController.text = selectedProduct.price.toString();
    _regularPriceController.text = selectedProduct.regularPrice.toString();
    _authorController.text = selectedProduct.authorOrManufacturer;
    _subCategoryController.text = selectedProduct.subCategory;
    _referenceController.text = selectedProduct.reference;
    _tagController.text = selectedProduct.tag.join(",");
    _descriptionController.text = selectedProduct.description;
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
                "Un Approved Products",
              ),
              margin: EdgeInsets.only(left: 20, top: 10),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: unApprovedProducts.length == 0
                    ? dataInitialized
                        ? Loading()
                        : NoDataFound()
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              dividerThickness: 0,
                              columns: const <DataColumn>[
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
                                    'Price (br)',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Shop',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Sub Cat',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                              rows: unApprovedProducts
                                  .map((Product e) => DataRow(cells: [
                                        DataCell(
                                          Container(
                                            width: 100,
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
                                              e.price.toString(),
                                              style: TextStyle(fontSize: 13, color: Colors.black54),
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                            ), onTap: () {
                                          onItemSelected(e);
                                        }),
                                        DataCell(
                                            Container(
                                              width: 100,
                                              child: Text(
                                                e.shop.name,
                                                style: TextStyle(fontSize: 13, color: Colors.black54),
                                                maxLines: 1,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ), onTap: () {
                                          onItemSelected(e);
                                        }),
                                        DataCell(
                                            Text(
                                              e.subCategory,
                                              style: TextStyle(fontSize: 13, color: Colors.black54),
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
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

  void onItemSelected(Product product) {
    setState(() {
      selectedProduct = product;
      setDetailData();
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
            Text("Detail"),
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
                    TextFormField(
                      style: TextStyle(fontSize: 14),

                      controller: _priceController,
                      decoration: InputDecoration(hintText: "price (br)", labelText: "price (br)"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 14),

                      controller: _regularPriceController,
                      decoration: InputDecoration(
                        hintText: "regular price (br)",
                        labelText: "regular price (br)",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter regular price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 14),

                      controller: _authorController,
                      decoration: InputDecoration(hintText: "author/maker", labelText: "author/maker"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter author/maker';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 14),

                      controller: _subCategoryController,
                      decoration: InputDecoration(hintText: "sub category", labelText: "sub category"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter sub category';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 14),
                      controller: _referenceController,
                      decoration: InputDecoration(hintText: "reference", labelText: "reference"),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 14),

                      controller: _tagController,
                      decoration: InputDecoration(hintText: "tags", labelText: "tags"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tags';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1, //Normal textInputField will be displayed
                      maxLines: 16, // when user presses enter it will adapt to it
                      controller: _descriptionController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "description",
                        labelText: "description",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            )),
            Container(
              padding: EdgeInsets.only(top: 40),
              margin: EdgeInsets.symmetric(horizontal: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Color(0xffe77681)),
                        child: Text("delete"),
                        onPressed: () {
                          onDeleteProduct(selectedProduct);
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
                        child: Text("accept"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            selectedProduct.name = _nameController.text;
                            selectedProduct.price = num.parse(_priceController.text);
                            selectedProduct.regularPrice = num.parse(_regularPriceController.text);
                            selectedProduct.authorOrManufacturer = _authorController.text;
                            selectedProduct.subCategory = _subCategoryController.text;
                            selectedProduct.reference = _referenceController.text;
                            selectedProduct.tag = _tagController.text.split(",");
                            selectedProduct.description = _descriptionController.text;

                            onAcceptProduct(selectedProduct);
                          }
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

  void onDeleteProduct(Product product) async {
    await firebaseAPI.deleteProduct(product);
    setState(() {
      unApprovedProducts.removeWhere((Product element) => product.productId == element.productId);
      selectedProduct = unApprovedProducts.first;
      setDetailData();
    });

    Fluttertoast.showToast(
        msg: "Successfully deleted product : ${product.name}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void onAcceptProduct(Product product) async {
    product.approved = true;
    product.keywords = product.name.split(" ");
    await firebaseAPI.updateProduct(product);
    setState(() {
      unApprovedProducts.removeWhere((Product element) => product.productId == element.productId);
      selectedProduct = unApprovedProducts.first;
      setDetailData();
    });
    Fluttertoast.showToast(
        msg: "Successfully approved product : ${product.name}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget buildProductImageView() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Image"),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedProduct.image.length,
                itemBuilder: (context, index) {
                  String img = selectedProduct.image[index];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(img),
                  );
                },
              ),
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
