import 'package:flutter/material.dart';
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/global.dart';
import 'package:product_approval_dashboard/widget/loading.dart';
import 'package:simple_tags/simple_tags.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  EdgeInsets _sectionPadding = EdgeInsets.symmetric(vertical: 15, horizontal: 20);
  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _categoryIconController = TextEditingController();
  TextEditingController _categoryFilterController = TextEditingController();
  TextEditingController _subCategoryNameController = TextEditingController();

  FbGlobalConfigAPI fbGlobalConfigAPI = FbGlobalConfigAPI();
  late GlobalConfig globalConfig;
  bool _globalConfigInitialized = false;


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
              Expanded(child: buildCategorySection()),
              Expanded(child: buildFeatureSection()),
              Expanded(
                child: Container(
                  child: Column(
                    children: [Expanded(child: buildBankConfigSection()), Expanded(child: buildSubscriptionPackageSection())],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                child: Column(
                  children: [
                    Expanded(child: buildTransactionFeeSection()),
                    Expanded(child: buildDeliveryFeeSection()),
                    Expanded(child: buildTaxSection()),
                    Container(
                      child: buildUpdaterButtonSection(),
                      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    )
                  ],
                ),
              ))
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

  Widget buildCategorySection() {
    return Column(
      children: [
        buildCreateCategorySS(),
        Expanded(flex: 2, child: buildViewCategorySS()),
        buildCreateSubCategorySS(),
        Expanded(flex: 2, child: buildViewSubCategorySS())
      ],
    );
  }

  Widget buildCreateCategorySS() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 14, color: Colors.red),
                controller: _categoryNameController,

                decoration: InputDecoration(hintText: "category name", labelText: "category name",suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 14,
                    ))),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category';
                  }
                  return null;
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


            ],
          )),
    );
  }

  Widget buildViewCategorySS() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: _sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(padding: EdgeInsets.only(left: 10),child: Text("${globalConfig.categories.length} categories", style: TextStyle(color: Colors.black54, fontSize: 12),),),
            Expanded(
                child: Container(
              child: ListView.builder(
                  itemCount: globalConfig.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      dense: true,
                      title: Text(globalConfig.categories[index].name),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.pink,
                          size: 14,
                        ),
                        onPressed: () {
                          // remove category
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

  Widget buildCreateSubCategorySS() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 14, color: Colors.red),
                controller: _categoryFilterController,

                decoration: InputDecoration(
                    hintText: "sub category name",
                    labelText: "sub category name",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.green,
                      ),
                      onPressed: () {},
                    )),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sub category';
                  }
                  return null;
                },
              ),
            ],
          )),
    );
  }

  Widget buildViewSubCategorySS() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

          Container(
            padding: EdgeInsets.only(left: 10, bottom: 10),
            child: Text("${globalConfig.categories.length} sub categories", style: TextStyle(color: Colors.black54, fontSize: 12),),),
          Expanded(child: SingleChildScrollView(scrollDirection: Axis.vertical,child: SimpleTags(
            content: globalConfig.categories[1].subCategories.cast<String>(),
            wrapSpacing: 4,
            wrapRunSpacing: 4,
            onTagPress: (tag) {print('pressed $tag');},
            onTagLongPress: (tag) {print('long pressed $tag');},
            onTagDoubleTap: (tag) {print('double tapped $tag');},
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
          ),),)
        ],),
      )
      
      
      ,
    );
  }

  Widget buildFeatureSection() {

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: _sectionPadding,
        child: Column(children: [
          SingleChildScrollView(scrollDirection: Axis.vertical,child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("about us"),
                  Switch(value: globalConfig.featuresConfig.aboutUs, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.aboutUs = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("best sellers"),
                  Switch(value: globalConfig.featuresConfig.bestSellers, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.bestSellers = value;}))
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("buy credit"),
                  Switch(value: globalConfig.featuresConfig.buyCredit, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.buyCredit = value;}))
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("cash out"),
                  Switch(value: globalConfig.featuresConfig.cashOut, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.cashOut = value;}))
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("force news on home"),
                  Switch(value: globalConfig.featuresConfig.forceNewsOnHome, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.forceNewsOnHome = value;}))
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("news"),
                  Switch(value: globalConfig.featuresConfig.news, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.news = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("order"),
                  Switch(value: globalConfig.featuresConfig.order, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.order = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("PM cash on delivery"),
                  Switch(value: globalConfig.featuresConfig.paymentMethodCashOnDelivery, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.paymentMethodCashOnDelivery = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("PM hisab wallet"),
                  Switch(value: globalConfig.featuresConfig.paymentMethodHisabWallet, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.paymentMethodHisabWallet = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("PM kelem wallet"),
                  Switch(value: globalConfig.featuresConfig.paymentMethodKelemWallet, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.paymentMethodKelemWallet = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("shop detail"),
                  Switch(value: globalConfig.featuresConfig.shopDetail, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.shopDetail = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("shop information"),
                  Switch(value: globalConfig.featuresConfig.shopInformation, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.shopInformation = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("tin"),
                  Switch(value: globalConfig.featuresConfig.tin, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.tin = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("transactions"),
                  Switch(value: globalConfig.featuresConfig.transactions, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.transactions = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("shop"),
                  Switch(value: globalConfig.featuresConfig.shop, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.shop = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("tin"),
                  Switch(value: globalConfig.featuresConfig.tin, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.tin = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("transactions"),
                  Switch(value: globalConfig.featuresConfig.transactions, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.transactions = value;}))
                ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("shop"),
                  Switch(value: globalConfig.featuresConfig.shop, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.shop = value;}))
                ],),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("wallet"),
                  Switch(value: globalConfig.featuresConfig.wallet, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.wallet = value;}))
                ],),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("wish list"),
                  Switch(value: globalConfig.featuresConfig.wishList, onChanged: (bool value) => setState(() {globalConfig.featuresConfig.wishList = value;}))
                ],),



            ],),)
        ],),
      ),
    );
  }

  Widget buildBankConfigSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        child: Center(
          child: Text("bank config"),
        ),
      ),
    );
  }

  Widget buildSubscriptionPackageSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        child: Center(
          child: Text("subscription package"),
        ),
      ),
    );
  }

  Widget buildTransactionFeeSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        child: Center(
          child: Text("build transaction fee"),
        ),
      ),
    );
  }

  Widget buildDeliveryFeeSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        child: Center(
          child: Text("build delivery fee"),
        ),
      ),
    );
  }

  Widget buildTaxSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        child: Center(
          child: Text("tax section"),
        ),
      ),
    );
  }

  Widget buildUpdaterButtonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: ElevatedButton(
          onPressed: () {},
          child: Text("cancel"),
        )),
        SizedBox(
          width: 10,
        ),
        Expanded(child: ElevatedButton(onPressed: () {}, child: Text("update"))),
      ],
    );
  }
}
