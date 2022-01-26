import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/global.dart';
import 'package:product_approval_dashboard/model/product.dart';
import 'package:product_approval_dashboard/model/shop.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:product_approval_dashboard/widget/no_data.dart';
import 'package:product_approval_dashboard/widget/stat_card.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class ProductApprovalPage extends StatefulWidget {
  @override
  _ProductApprovalPageState createState() => _ProductApprovalPageState();
}

class _ProductApprovalPageState extends State<ProductApprovalPage> {
  final _formKey = GlobalKey<FormState>();

  FbProductAPI firebaseAPI = FbProductAPI();
  FbGlobalConfigAPI fbGlobalConfigAPI = FbGlobalConfigAPI();

  TsAPI tsAPI = TsAPI();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _regularPriceController = TextEditingController();
  TextEditingController _authorController = TextEditingController();

  TextEditingController _categoryController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  TextEditingController _tagController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<Product> unApprovedProducts = [];
  bool dataInitialized = false;
  Product selectedProduct = Product(shop: Shop(firstModified: DateTime.now(), lastModified: DateTime.now()), firstModified: DateTime.now(), lastModified: DateTime.now());

  List<String> allSubCategoriesOfShop = [];
  List<Category> globalCategories = [];
  late GlobalConfig globalConfigValue;

  // flutter build web --web-renderer html --release
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    // firebaseAPI.updateProductsDeletedFlag();
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
    await fbGlobalConfigAPI.get().then((GlobalConfig value) {
      globalCategories = value.categories;
      globalConfigValue = value;
    });

    setState(() {
      unApprovedProducts = data;
      selectedProduct = unApprovedProducts.first;
      setDetailData();
      allSubCategoriesOfShop = globalCategories.firstWhere((element) => selectedProduct.shop.category == element.name).subCategories.map((e) => e.toString()).toList();

      dataInitialized = true;
    });
  }

  void setDetailData() {
    _nameController.text = selectedProduct.name;
    _priceController.text = selectedProduct.price.toString();
    _regularPriceController.text = selectedProduct.regularPrice.toString();
    _authorController.text = selectedProduct.authorOrManufacturer;
    _categoryController.text = selectedProduct.category;
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
      allSubCategoriesOfShop = globalCategories.firstWhere((element) => product.shop.category == element.name).subCategories.map((e) => e.toString()).toList();
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
              SelectableText(selectedProduct.productId)
            ],),
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
                    SimpleAutocompleteFormField<String>(
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "category",
                      ),
                      controller: _categoryController,
                      maxSuggestions: 10,
                      itemBuilder: (context, item) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(item!),
                      ),
                      onSearch: (String search) async => search.isEmpty
                          ? globalCategories.map((e) => e.name).toList()
                          : globalCategories.map((e) => e.name).toList().where((selectedCat) {
                              return selectedCat.toLowerCase().contains(search.toLowerCase());
                            }).toList(),
                      itemFromString: (string) {
                        return globalCategories.map((e) => e.name).toList().singleWhere((selectedCat) => selectedCat == string.toLowerCase(), orElse: () => '');
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedProduct.category = value!;
                          allSubCategoriesOfShop = globalCategories.firstWhere((element) => selectedProduct.category == element.name).subCategories.map((e) => e.toString()).toList();
                        });
                      },
                      validator: (selectedCat) {
                        if (selectedCat == null) {
                          return 'Please enter category';
                        } else if (!globalCategories.map((e) => e.name).toList().contains(selectedCat.toString())) {
                          return 'Category does not exist';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SimpleAutocompleteFormField<String>(
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "sub category",
                      ),
                      controller: _subCategoryController,
                      maxSuggestions: 10,
                      itemBuilder: (context, item) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(item!),
                      ),
                      onSearch: (String search) async => search.isEmpty
                          ? allSubCategoriesOfShop
                          : allSubCategoriesOfShop.where((selectedSubCat) {
                              return selectedSubCat.toLowerCase().contains(search.toLowerCase());
                            }).toList(),
                      itemFromString: (string) {
                        return allSubCategoriesOfShop.singleWhere((selectedSubCat) => selectedSubCat == string.toLowerCase(), orElse: () => '');
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedProduct.subCategory = value!;
                        });
                      },
                      validator: (selectedSubCat) {
                        return selectedSubCat == null ? 'Please enter sub category' : null;
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
                            selectedProduct.category = _categoryController.text;
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
    await firebaseAPI.createDeletedProduct(product);
    await firebaseAPI.deleteTotalyProduct(product);

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

  void approveProduct(Product product) async {
    product.approved = true;
    product.keywords = product.name.split(" ");
    await firebaseAPI.updateProduct(product);
    setState(() {
      unApprovedProducts.removeWhere((Product element) => product.productId == element.productId);
      selectedProduct = unApprovedProducts.first;
      setDetailData();
    });

    tsAPI.indexProduct(product);
    Fluttertoast.showToast(
        msg: "Successfully approved product : ${product.name}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void onAcceptProduct(Product product) async {
    if (!allSubCategoriesOfShop.contains(product.subCategory)) {
      await showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
            return Center(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(style: TextStyle(color: Colors.black87), text: "", children: [
                          TextSpan(text: "Do you want to add sub category"),
                          TextSpan(text: " ${product.subCategory}", style: TextStyle(fontWeight: FontWeight.w900)),
                          TextSpan(text: " in ${product.shop.category} category?\n\n\n\n"),
                          TextSpan(text: "Existing subcategories in ${product.shop.category}\n\n", style: TextStyle(fontSize: 12)),
                          TextSpan(text: allSubCategoriesOfShop.join("  "), style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor))
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            addNewSubCategoryEntry();
                            approveProduct(product);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "create a new subcategory ' ${product.subCategory} ' in category ${product.shop.category} and approve product",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(primary: Color(0xffe77681)))
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      approveProduct(product);
    }
  }

  void addNewSubCategoryEntry() async {
    globalConfigValue.categories.forEach((Category element) {
      if (element.name == selectedProduct.shop.category) {
        element.subCategories.add(selectedProduct.subCategory);
      }
    });
    await fbGlobalConfigAPI.update(globalConfigValue);
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
