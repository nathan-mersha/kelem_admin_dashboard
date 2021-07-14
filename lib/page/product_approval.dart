import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/product.dart';
import 'package:product_approval_dashboard/model/shop.dart';

class ProductApprovalPage extends StatefulWidget {
  @override
  _ProductApprovalPageState createState() => _ProductApprovalPageState();
}

class _ProductApprovalPageState extends State<ProductApprovalPage> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAPI firebaseAPI = FirebaseAPI();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _regularPriceController = TextEditingController();
  TextEditingController _authorController = TextEditingController();

  TextEditingController _subCategoryController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  TextEditingController _tagController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<Product> unApprovedProducts = [];
  Product selectedProduct = Product(shop: Shop(firstModified: DateTime.now(), lastModified: DateTime.now()), firstModified: DateTime.now(), lastModified: DateTime.now());

  // flutter build web --web-renderer html --release
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black12,
        child: Row(
          children: [
            Expanded(flex: 1, child: buildSideMenu()),
            Expanded(
                flex: 22,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
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
                                        child: buildStat(
                                            title: "Un Approved",
                                            description: "pending approval items",
                                            stat: unApprovedProducts.length,
                                            icon: Icon(
                                              Icons.error_outline_rounded,
                                              size: 20,
                                              color: Colors.pink,
                                            )),
                                      ),
                                      Expanded(
                                        child: buildStat(
                                            title: "Approved",
                                            description: "total approved products",
                                            stat: 0,
                                            icon: Icon(
                                              Icons.check_circle_rounded,
                                              size: 20,
                                              color: Colors.orange,
                                            )),
                                      ),
                                      Expanded(
                                        child: buildStat(
                                            title: "Total",
                                            description: "total item in database",
                                            stat: 0,
                                            icon: Icon(
                                              Icons.all_inclusive,
                                              size: 20,
                                              color: Colors.cyan,
                                            )),
                                      )
                                    ],
                                  )),

                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [Expanded(flex: 2, child: buildProductDetail()), Expanded(flex: 1, child: buildProductImageView())],
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                )),
          ],
        ));
  }

  void initializeData() async {
    List<Product> data = await firebaseAPI.getUnApprovedProducts();
    setState(() {
      unApprovedProducts = data;
      selectedProduct = unApprovedProducts.first;
      setDetailData();
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Products"),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: unApprovedProducts.length == 0
                    ? Container(
                        child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_download_outlined,
                              color: Theme.of(context).accentColor,
                              size: 40,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "loading products",
                              style: TextStyle(fontSize: 11, color: Colors.black54),
                            )
                          ],
                        ),
                      ))
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
                                    'Sub category',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Maker',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Price',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                              rows: unApprovedProducts
                                  .map((Product e) => DataRow(

                                  cells: [
                                        DataCell(
                                            Container(
                                          width: 130,
                                          child: Text(
                                            e.name,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54
                                            ),
                                            maxLines: 1,
                                          ),
                                        ), onTap: (){
                                             onItemSelected(e);
                                        },),
                                        DataCell(Text(
                                          e.subCategory,
                                          style: TextStyle(fontSize: 13, color: Colors.black54),
                                          maxLines: 1,
                                        ), onTap: (){
                                          onItemSelected(e);
                                        }),
                                        DataCell(Text(
                                          e.authorOrManufacturer.toString(),
                                          style: TextStyle(fontSize: 13, color: Colors.black54),
                                          maxLines: 1,
                                        ), onTap: (){
                                          onItemSelected(e);
                                        }),
                                        DataCell(Text(
                                          e.price.toString(),
                                          style: TextStyle(fontSize: 13, color: Colors.black54),
                                          maxLines: 1,
                                        ), onTap: (){
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

  Widget buildUnApprovedStat() {
    return Card(
      color: Colors.blue,
    );
  }

  void onItemSelected(Product product){
    setState(() {
      selectedProduct  = product;
      setDetailData();
    });
  }
  Widget buildStat({required String title, required String description, required num stat, required Icon icon}) {
    return Container(
      child: Card(
        elevation: 0.5,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                  icon
                ],
              ),
              Text(stat.toString(), style: TextStyle(fontSize: 18, color: Colors.black45)),
              Expanded(child: Container()),
              Text(
                description,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
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
                      controller: _regularPriceController,
                      decoration: InputDecoration(hintText: "regular price (br)", labelText: "regular price (br)", ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter regular price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
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
                      controller: _referenceController,
                      decoration: InputDecoration(hintText: "reference", labelText: "reference"),
                    ),
                    TextFormField(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
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
                    height: 40,
                    child: ElevatedButton(
                      child: Text("accept"),
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
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
            )
          ],
        ),
      ),
    );
  }

  void onDeleteProduct(Product product) async{
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
        fontSize: 16.0
    );
  }

  void onAcceptProduct(Product product) async{
      product.approved = true;
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
          fontSize: 16.0
      );
  }

  Widget buildProductImageView() {
    return Card(
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
                  return Image.network(img);
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
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        children: [Image.asset("assets/images/logo.png")],
      ),
    );
  }


}
