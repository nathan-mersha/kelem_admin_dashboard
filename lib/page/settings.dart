import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/global.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:simple_tags/simple_tags.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String MESSAGE_TYPE_NOTIFICATION = "message notification";
  static const String MESSAGE_TYPE_ERROR = "message error";

  static const String UPDATE = "update";
  static const String CREATE = "create";

  EdgeInsets _sectionPadding = EdgeInsets.symmetric(vertical: 15, horizontal: 20);

  // Category form controllers
  String categoryFormMode = CREATE;
  final _formCreateCategoryKey = GlobalKey<FormState>();
  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _categoryIconController = TextEditingController();
  TextEditingController _subCategoryNameController = TextEditingController();

  // Bank Config form controllers
  String bankConfigFormMode = CREATE;
  final _formCreateBankConfigKey = GlobalKey<FormState>();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _bankCodeController = TextEditingController();
  TextEditingController _bankIconController = TextEditingController();
  TextEditingController _depositToDiallingPatternController = TextEditingController();
  TextEditingController _kelemBankAccountController = TextEditingController();

  // Subscription package form controllers
  String subscriptionPackageFormMode = CREATE;
  final _formCreateSubscriptionPackageKey = GlobalKey<FormState>();

  TextEditingController _subscriptionNameController = TextEditingController();
  TextEditingController _subscriptionFeaturesController = TextEditingController();
  TextEditingController _subscriptionMonthlyPriceController = TextEditingController();
  TextEditingController _subscriptionYearlyPriceController = TextEditingController();

  // Extra payment config
  String extraPaymentConfigFormMode = CREATE;
  final _formCreateExtraPaymentKey = GlobalKey<FormState>();

  FbGlobalConfigAPI fbGlobalConfigAPI = FbGlobalConfigAPI();
  late GlobalConfig globalConfig;
  late GlobalConfig oldGlobalConfigData;
  bool _globalConfigInitialized = false;
  bool _globalConfigEdited = false;

  double _switchButtonScale = 0.8;

  int selectedCategoryIndex = 0;
  int selectedSubscriptionIndex = 0;
  int selectedBankConfigIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return _globalConfigInitialized
        ? Row(
            children: [
              Expanded(flex: 1, child: buildCategorySection()),
              Expanded(flex: 1, child: buildFeatureSection()),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: [Expanded(flex: 3, child: buildBankConfigSection()), Expanded(flex: 2, child: buildExtraPaymentConfig())],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [Expanded(flex: 8, child: buildSubscriptionPackageSection()), Expanded(flex: 1, child: buildUpdaterButtonSection())],
                  )),
            ],
          )
        : Loading();
  }

  void initializeData() async {
    await fbGlobalConfigAPI.get().then((GlobalConfig value) {
      setState(() {
        globalConfig = value;
        _globalConfigInitialized = true;
      });
    });
  }

  void resetGlobalConfigData() async {
    await fbGlobalConfigAPI.get().then((GlobalConfig value) {
      setState(() {
        globalConfig = value;
        _globalConfigInitialized = true;
        showToastNotification("Successfully reseted globally config");
      });
    });
  }

  void updateGlobalConfigData() async {
    await fbGlobalConfigAPI.update(globalConfig).then((value){
      setState(() {
        _globalConfigInitialized = true;
        showToastNotification("Successfully updated globally config");
      });
    });

  }

  Widget buildCategorySection() {
    return Column(
      children: [buildCreateCategorySS(), Expanded(flex: 2, child: buildViewCategorySS()), Expanded(flex: 2, child: buildViewSubCategorySS())],
    );
  }

  Widget buildCreateCategorySS() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formCreateCategoryKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: _categoryNameController,

                    decoration: InputDecoration(
                      hintText: "category name",
                      labelText: "category name",
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter category name';
                      } else {
                        if (categoryFormMode == CREATE) {
                          bool categoryExists = false;
                          globalConfig.categories.forEach((Category element) {
                            if (element.name == value) {
                              categoryExists = true;
                            }
                          });
                          return categoryExists ? "Category $value already exists" : null;
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14),

                    controller: _categoryIconController,
                    decoration: InputDecoration(hintText: "icon", labelText: "icon"),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter icon';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: _subCategoryNameController,

                    decoration: InputDecoration(
                      hintText: "add sub category ( separated by ,)",
                      labelText: "sub category",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter at least one subcategory';
                      }else if(!value.contains("unknown")){
                        return 'unknown subcategory is required';
                      }
                      return null;
                    },
                    // The validator receives the text that the user has entered.
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (categoryFormMode == CREATE) {
                              onCreateNewCategory();
                            } else {
                              onUpdateCategory();
                            }
                          },
                          icon: Icon(
                            categoryFormMode == CREATE ? Icons.check_circle_sharp : Icons.watch_later_rounded,
                            color: categoryFormMode == CREATE ? Colors.green : Colors.orangeAccent,
                            // size: 14,
                          )),
                      IconButton(
                          onPressed: () {
                            onCancelCategoryCreate();
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: Color(0xffe77681),
                            // size: 14,
                          )),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  void onCreateNewBankConfig() {
    if (_formCreateBankConfigKey.currentState!.validate()) {
      BankConfig bankConfig = BankConfig(
          bankName: _bankNameController.text,
          bankCode: _bankCodeController.text,
          icon: _bankIconController.text,
          depositToDiallingPattern: _depositToDiallingPatternController.text,
          kelemBankAccount: _kelemBankAccountController.text);

      setState(() {
        globalConfig.bankConfigs.add(bankConfig);
        clearBankConfigFields();
      });

      showToastNotification("Added new bank config for ${bankConfig.bankName}");
      onGlobalConfigEdited();
    }
  }

  void onUpdateBankConfig() {
    if (_formCreateBankConfigKey.currentState!.validate()) {
      BankConfig selectedBankConfig = globalConfig.bankConfigs[selectedBankConfigIndex];
      selectedBankConfig.bankName = _bankNameController.text;
      selectedBankConfig.bankCode = _bankCodeController.text;
      selectedBankConfig.depositToDiallingPattern = _depositToDiallingPatternController.text;
      selectedBankConfig.icon = _bankIconController.text;
      selectedBankConfig.kelemBankAccount = _kelemBankAccountController.text;

      setState(() {
        globalConfig.bankConfigs.removeAt(selectedBankConfigIndex);
        globalConfig.bankConfigs.add(selectedBankConfig);
        clearBankConfigFields();
        bankConfigFormMode = CREATE;
      });

      showToastNotification("Updated bank config ${selectedBankConfig.bankName}");
      onGlobalConfigEdited();
    }
  }

  void onCancelBankConfig() {
    setState(() {
      clearBankConfigFields();
      bankConfigFormMode = CREATE;
    });
  }

  void onDeleteBankConfig(BankConfig bankConfig) async {
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
                    Text("Really want to delete ${bankConfig.bankName} configuration?"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                globalConfig.bankConfigs.remove(bankConfig);
                              });
                              showToastNotification("Removed bank config for ${bankConfig.bankName}");
                              onGlobalConfigEdited();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xffe77681)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void onCreateNewSubscriptionPackage() {
    if (_formCreateSubscriptionPackageKey.currentState!.validate()) {
      SubscriptionPackage subscriptionPackage = SubscriptionPackage(
          name: _subscriptionNameController.text,
          features: _subscriptionFeaturesController.text.split(","),
          monthlyPrice: num.parse(_subscriptionMonthlyPriceController.text),
          yearlyPrice: num.parse(_subscriptionYearlyPriceController.text));

      setState(() {
        globalConfig.subscriptionPackages.add(subscriptionPackage);
      });

      clearSubscriptionFields();
      showToastNotification("Added new subscription package ${subscriptionPackage.name}");
      onGlobalConfigEdited();
    }
  }

  void onUpdateSubscriptionPackage() {
    if (_formCreateSubscriptionPackageKey.currentState!.validate()) {
      SubscriptionPackage selectedSubscriptionPackage = globalConfig.subscriptionPackages[selectedSubscriptionIndex];

      selectedSubscriptionPackage.name = _subscriptionNameController.text;
      selectedSubscriptionPackage.features = _subscriptionFeaturesController.text.split(",");
      selectedSubscriptionPackage.monthlyPrice = num.parse(_subscriptionMonthlyPriceController.text);
      selectedSubscriptionPackage.yearlyPrice = num.parse(_subscriptionYearlyPriceController.text);

      setState(() {
        globalConfig.subscriptionPackages.removeAt(selectedSubscriptionIndex);
        globalConfig.subscriptionPackages.add(selectedSubscriptionPackage);

        clearSubscriptionFields();
        subscriptionPackageFormMode = CREATE;
      });

      showToastNotification("Updated subscription package ${selectedSubscriptionPackage.name}");
      onGlobalConfigEdited();
    }
  }

  void onDeleteSubscriptionPackage(SubscriptionPackage subscriptionPackage) async {
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
                    Text("Really want to delete subscription package ${subscriptionPackage.name}?"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                globalConfig.subscriptionPackages.remove(subscriptionPackage);
                                clearCategoryCreatorFields();
                              });

                              showToastNotification("Removed category ${subscriptionPackage.name}");
                              onGlobalConfigEdited();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xffe77681)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void onCancelSubscriptionPackage() {
    setState(() {
      clearSubscriptionFields();
      subscriptionPackageFormMode = CREATE;
      selectedSubscriptionIndex = 0;
    });
  }

  void onCreateNewCategory() {
    if (_formCreateCategoryKey.currentState!.validate()) {
      String name = _categoryNameController.text;
      String icon = _categoryIconController.text;
      List<String> subCategories = _subCategoryNameController.text.isEmpty ? [] : _subCategoryNameController.text.split(",");

      Category newCategory = Category(name: name, icon: icon, subCategories: subCategories);
      setState(() {
        globalConfig.categories.add(newCategory);
        clearCategoryCreatorFields();
      });
      showToastNotification("Added new category $name with ${subCategories.length} sub categories");
      onGlobalConfigEdited();
    }
  }

  void onUpdateCategory() {
    if (_formCreateCategoryKey.currentState!.validate()) {
      Category selectedCategory = globalConfig.categories[selectedCategoryIndex];
      selectedCategory.name = _categoryNameController.text;
      selectedCategory.icon = _categoryIconController.text;
      selectedCategory.subCategories = _subCategoryNameController.text.split(",");

      setState(() {
        globalConfig.categories.removeAt(selectedCategoryIndex);
        globalConfig.categories.add(selectedCategory);

        clearCategoryCreatorFields();
        categoryFormMode = CREATE;
      });

      showToastNotification("Updated category ${selectedCategory.name}");
      onGlobalConfigEdited();
    }
  }

  void onRemoveSubCategory(String subCategory) {
    Category category = globalConfig.categories[selectedCategoryIndex];
    setState(() {
      category.subCategories.remove(subCategory);
      onGlobalConfigEdited();
      showToastNotification("Removed sub-category $subCategory from ${category.name}");
    });
  }

  void clearCategoryCreatorFields() {
    _categoryNameController.clear();
    _categoryIconController.clear();
    _subCategoryNameController.clear();
  }

  void clearBankConfigFields() {
    _bankNameController.clear();
    _bankCodeController.clear();
    _bankIconController.clear();
    _depositToDiallingPatternController.clear();
    _kelemBankAccountController.clear();
  }

  void clearSubscriptionFields() {
    _subscriptionNameController.clear();
    _subscriptionFeaturesController.clear();
    _subscriptionMonthlyPriceController.clear();
    _subscriptionYearlyPriceController.clear();
  }

  void onCancelCategoryCreate() {
    setState(() {
      clearCategoryCreatorFields();
      categoryFormMode = CREATE;
      selectedCategoryIndex = 0;
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

  void onGlobalConfigEdited() {
    setState(() {
      _globalConfigEdited = true;
    });
  }

  Widget buildViewCategorySS() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: _sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              child: Text(
                "${globalConfig.categories.length} categories",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
            Expanded(
                child: Container(
              child: ListView.builder(
                  itemCount: globalConfig.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        onPressedCategory(index);
                      },
                      selected: selectedCategoryIndex == index,
                      selectedTileColor: Colors.black12,
                      dense: true,
                      title: Text(globalConfig.categories[index].name),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Color(0xffe77681),
                          size: 14,
                        ),
                        onPressed: () {
                          // remove category
                          onDeleteCategory(index);
                        },
                      ),
                    );
                  }),
            ))
          ],
        ),
      ),
    );
  }

  void onPressedCategory(int index) {
    Category selectedCategory = globalConfig.categories[index];

    setState(() {
      selectedCategoryIndex = index;

      _categoryNameController.text = selectedCategory.name;
      _categoryIconController.text = selectedCategory.icon;
      _subCategoryNameController.text = selectedCategory.subCategories.join(",");

      categoryFormMode = UPDATE;
    });
  }

  void onDeleteCategory(int index) async {
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
                    Text("Really want to delete category ${globalConfig.categories[index].name} and all ${globalConfig.categories[index].subCategories.length} sub categories?"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              String nameOfCategory = globalConfig.categories[index].name;

                              setState(() {
                                globalConfig.categories.removeAt(index);
                                clearCategoryCreatorFields();
                              });

                              showToastNotification("Removed category $nameOfCategory");
                              onGlobalConfigEdited();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xffe77681)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildViewSubCategorySS() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 20),
              child: Row(
                children: [
                  Text(
                    "${globalConfig.categories[selectedCategoryIndex].subCategories.length} Sub-categories",
                    style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SimpleTags(
                  content: globalConfig.categories[selectedCategoryIndex].subCategories.cast<String>(),
                  wrapSpacing: 4,
                  wrapRunSpacing: 4,
                  onTagPress: (subCategory) {
                    onRemoveSubCategory(subCategory);
                  },
                  tagContainerPadding: EdgeInsets.all(6),
                  tagTextStyle: TextStyle(color: Colors.deepPurple),
                  tagIcon: Icon(Icons.clear, size: 12),
                  tagContainerDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(139, 139, 142, 0.16),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1.75, 3.5), // c
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFeatureSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
          padding: _sectionPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("about us"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.aboutUs,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.aboutUs = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("best sellers"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.bestSellers,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.bestSellers = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("buy credit"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.buyCredit,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.buyCredit = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("cash out"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.cashOut,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.cashOut = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("force news on home"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.forceNewsOnHome,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.forceNewsOnHome = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("news"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.news,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.news = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("order"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.order,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.order = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("PM cash on delivery"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.paymentMethodCashOnDelivery,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.paymentMethodCashOnDelivery = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("PM hisab wallet"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.paymentMethodHisabWallet,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.paymentMethodHisabWallet = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("PM kelem wallet"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.paymentMethodKelemWallet,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.paymentMethodKelemWallet = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("shop detail"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.shopDetail,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.shopDetail = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("shop information"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.shopInformation,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.shopInformation = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("transactions"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.transactions,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.transactions = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("shop"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.shop,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.shop = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("tin"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.tin,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.tin = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("transactions"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.transactions,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.transactions = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("shop"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.shop,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.shop = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("wallet"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.wallet,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.wallet = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("wish list"),
                        Transform.scale(
                          scale: _switchButtonScale,
                          child: Switch(
                              value: globalConfig.featuresConfig.wishList,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) => setState(() {
                                    globalConfig.featuresConfig.wishList = value;
                                    onGlobalConfigEdited();
                                  })),
                        )
                      ],
                    ),
                  ],
                ),
              )),
              // Expanded(child: Container(),)
            ],
          )),
    );
  }

  Widget buildBankConfigSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formCreateBankConfigKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: _bankNameController,
                    decoration: InputDecoration(
                      hintText: "bank name",
                      labelText: "bank name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bank name';
                      }

                      if (bankConfigFormMode == CREATE) {
                        if (globalConfig.bankConfigs.any((BankConfig element) => element.bankName == value)) {
                          return "Bank name already exists in config";
                        }
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: _bankCodeController,
                    decoration: InputDecoration(
                      hintText: "bank code",
                      labelText: "bank code",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bank code';
                      }

                      if (bankConfigFormMode == CREATE) {
                        if (globalConfig.bankConfigs.any((BankConfig element) => element.bankCode == value)) {
                          return "Bank code already exists in config";
                        }
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: _bankIconController,
                    decoration: InputDecoration(
                      hintText: "bank icon",
                      labelText: "bank icon",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bank icon';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14),

                    controller: _depositToDiallingPatternController,
                    decoration: InputDecoration(hintText: "dialling pattern", labelText: "deposit to dialling pattern"),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter deposit to dialling pattern';
                      } else if (!value.contains("PIN_1")) {
                        return "Dialling pattern must contain 'PIN_1' key";
                      } else if (!value.contains("AMOUNT")) {
                        return "Dialling pattern must contain 'AMOUNT' key";
                      } else if (!value.contains("TRN_DES")) {
                        return "Dialling pattern must contain 'TRN_DES' key";
                      } else if (!value.startsWith("*")) {
                        return "Dialling pattern must begin with *";
                      } else if (!value.endsWith("#")) {
                        return "Dialling pattern must end with #";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: _kelemBankAccountController,
                    decoration: InputDecoration(
                      hintText: "kelem bank account",
                      labelText: "kelem account",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter kelem bank/wallet account no.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (bankConfigFormMode == CREATE) {
                              onCreateNewBankConfig();
                            } else {
                              onUpdateBankConfig();
                            }
                          },
                          icon: Icon(
                            bankConfigFormMode == CREATE ? Icons.check_circle_sharp : Icons.watch_later_rounded,
                            color: bankConfigFormMode == CREATE ? Colors.green : Colors.orangeAccent,
                            // size: 14,
                          )),
                      IconButton(
                          onPressed: () {
                            onCancelBankConfig();
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: Color(0xffe77681),
                            // size: 14,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  buildBankConfigTable()
                ],
              ),
            ),
          )),
    );
  }

  Widget buildSubscriptionPackageSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: ListView(
          children: [buildSubscriptionPackageFormSection(), buildSubscriptionListViewSection()],
        ),
      ),
    );
  }

  Widget buildSubscriptionPackageFormSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formCreateSubscriptionPackageKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 14),
                controller: _subscriptionNameController,
                decoration: InputDecoration(
                  hintText: "subscription name",
                  labelText: "subscription name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subscription name';
                  }
                  if (subscriptionPackageFormMode == CREATE) {
                    if (globalConfig.subscriptionPackages.any((SubscriptionPackage element) => element.name == value)) {
                      return "Subscription name already exists in config";
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(fontSize: 14),
                controller: _subscriptionMonthlyPriceController,
                decoration: InputDecoration(
                  hintText: "monthly price",
                  labelText: "monthly price",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly price';
                  } else {
                    num? parsedValue = num.tryParse(value);
                    if (parsedValue == null) {
                      return "Monthly price must be a number";
                    }
                    return null;
                  }
                },
              ),
              TextFormField(
                style: TextStyle(fontSize: 14),
                controller: _subscriptionYearlyPriceController,
                decoration: InputDecoration(
                  hintText: "yearly price",
                  labelText: "yearly price",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter yearly price';
                  } else {
                    num? parsedValue = num.tryParse(value);
                    if (parsedValue == null) {
                      return "Yearly price must be a number";
                    }
                    return null;
                  }
                },
              ),
              TextFormField(
                style: TextStyle(fontSize: 14),
                maxLines: 8,
                minLines: 8,
                controller: _subscriptionFeaturesController,
                decoration: InputDecoration(
                  hintText: "features (separated by ,)",
                  labelText: "features",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter features';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        if (subscriptionPackageFormMode == CREATE) {
                          onCreateNewSubscriptionPackage();
                        } else {
                          onUpdateSubscriptionPackage();
                        }
                      },
                      icon: Icon(
                        subscriptionPackageFormMode == CREATE ? Icons.check_circle_sharp : Icons.watch_later_rounded,
                        color: subscriptionPackageFormMode == CREATE ? Colors.green : Colors.orangeAccent,
                        // size: 14,
                      )),
                  IconButton(
                      onPressed: () {
                        onCancelSubscriptionPackage();
                      },
                      icon: Icon(
                        Icons.cancel_rounded,
                        color: Color(0xffe77681),
                        // size: 14,
                      )),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget buildSubscriptionListViewSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      color: Colors.black12.withOpacity(0.05),
      elevation: 0,
      child: Container(
        child: SingleChildScrollView(
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
                    numeric: true,
                    label: Text(
                      'Yearly',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
                rows: globalConfig.subscriptionPackages
                    .map((SubscriptionPackage e) => DataRow(cells: [
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
                              onSubscriptionPackageSelected(e);
                            },
                          ),
                          DataCell(
                              Container(
                                child: Text(
                                  e.yearlyPrice.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 13, color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ), onTap: () {
                            onSubscriptionPackageSelected(e);
                          }),
                          DataCell(Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Color(0xffe77681),
                                size: 14,
                              ),
                              onPressed: () {
                                // remove category
                                onDeleteSubscriptionPackage(e);
                              },
                            ),
                          ))
                        ]))
                    .toList()),
          ),
        ),
      ),
    );
  }

  Widget buildExtraPaymentConfig() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formCreateExtraPaymentKey,
          onChanged: () {
            onGlobalConfigEdited();
          },
          child: Container(
            padding: EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "transaction Fee",
                          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
                          items: ["flat rate", "percentage"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value, style: TextStyle(fontSize: 14, color: Colors.black87)),
                            );
                          }).toList(),
                          value: globalConfig.additionalFee.transactionFeeType,
                          isExpanded: true,
                          hint: Text(
                            "calculation type",
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                            textAlign: TextAlign.end,
                          ),
                          onChanged: (value) {
                            setState(() {
                              globalConfig.additionalFee.transactionFeeType = value!;
                            });
                          },
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          initialValue: globalConfig.additionalFee.transactionFeeValue.toString(),
                          decoration: InputDecoration(
                            hintText: "transaction fee",
                            labelText: "transaction fee",
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter transaction fee';
                            } else {
                              num? parsedValue = num.tryParse(value);
                              if (parsedValue == null) {
                                return "Transaction price must be a number";
                              }
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "tax",
                          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14),
                          initialValue: globalConfig.additionalFee.taxFeeValue.toString(),
                          decoration: InputDecoration(
                            hintText: "tax",
                            labelText: "tax",
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter tax';
                            } else {
                              num? parsedValue = num.tryParse(value);
                              if (parsedValue == null) {
                                return "Tax must be a number";
                              }
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "delivery Fee",
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        items: ["flat rate", "percentage"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          );
                        }).toList(),
                        value: globalConfig.additionalFee.deliveryFeeType,
                        isExpanded: true,
                        hint: Text(
                          "calculation type",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.end,
                        ),
                        onChanged: (value) {
                          setState(() {
                            globalConfig.additionalFee.deliveryFeeType = value!;
                          });
                        },
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 14),
                        initialValue: globalConfig.additionalFee.deliveryFeeValue.toString(),
                        decoration: InputDecoration(
                          hintText: "delivery fee",
                          labelText: "delivery fee",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter delivery fee';
                          } else {
                            num? parsedValue = num.tryParse(value);
                            if (parsedValue == null) {
                              return "Delivery fee must be a number";
                            }
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onUpdateTransactionUpdate() {}
  Widget buildUpdaterButtonSection() {
    return AbsorbPointer(
      absorbing: !_globalConfigEdited,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                onResetGlobalConfig();
              },
              style: ElevatedButton.styleFrom(primary: _globalConfigEdited ? Color(0xffe77681) : Colors.black38),
              child: Text("reset"),
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      onUpdateGlobalConfig();
                    },
                    child: Text("update"),
                    style: ElevatedButton.styleFrom(primary: _globalConfigEdited ? Color(0xff9299cd) : Colors.black38))),
          ],
        ),
      ),
    );
  }

  void onResetGlobalConfig() async {
    await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Really want to reset global config?"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              resetGlobalConfigData();

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "reset",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xffe77681)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void onUpdateGlobalConfig() async{
    await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Really want to update global config?"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xff9299cd))),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              updateGlobalConfigData();

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "update",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Color(0xffe77681)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void onBankConfigSelected(BankConfig bankConfig) {
    setState(() {
      selectedBankConfigIndex = globalConfig.bankConfigs.indexOf(bankConfig);
      _bankNameController.text = bankConfig.bankName;
      _bankCodeController.text = bankConfig.bankCode;
      _bankIconController.text = bankConfig.icon;
      _depositToDiallingPatternController.text = bankConfig.depositToDiallingPattern;
      _kelemBankAccountController.text = bankConfig.kelemBankAccount;

      bankConfigFormMode = UPDATE;
    });
  }

  void onSubscriptionPackageSelected(SubscriptionPackage subscriptionPackage) {
    setState(() {
      selectedSubscriptionIndex = globalConfig.subscriptionPackages.indexOf(subscriptionPackage);
      _subscriptionNameController.text = subscriptionPackage.name;

      _subscriptionFeaturesController.text = subscriptionPackage.features.join(",");
      _subscriptionMonthlyPriceController.text = subscriptionPackage.monthlyPrice.toString();
      _subscriptionYearlyPriceController.text = subscriptionPackage.yearlyPrice.toString();

      subscriptionPackageFormMode = UPDATE;
    });
  }

  Widget buildBankConfigTable() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      color: Colors.black12.withOpacity(0.05),
      elevation: 0,
      child: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                dividerThickness: 0,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Code',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Pattern',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
                rows: globalConfig.bankConfigs
                    .map((BankConfig e) => DataRow(cells: [
                          DataCell(
                            Container(
                              // width: 100,
                              child: Text(
                                e.bankCode,
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                                maxLines: 1,
                              ),
                            ),
                            onTap: () {
                              onBankConfigSelected(e);
                            },
                          ),
                          DataCell(
                              Text(
                                e.bankName,
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ), onTap: () {
                            onBankConfigSelected(e);
                          }),
                          DataCell(
                              Container(
                                child: Text(
                                  e.depositToDiallingPattern,
                                  style: TextStyle(fontSize: 13, color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ), onTap: () {
                            onBankConfigSelected(e);
                          }),
                          DataCell(Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Color(0xffe77681),
                                size: 14,
                              ),
                              onPressed: () {
                                // remove category
                                onDeleteBankConfig(e);
                              },
                            ),
                          ))
                        ]))
                    .toList()),
          ),
        ),
      ),
    );
  }
}
