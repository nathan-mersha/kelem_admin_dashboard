import 'package:flutter/material.dart';
import 'package:product_approval_dashboard/api/firebase_api.dart';
import 'package:product_approval_dashboard/model/global.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _categoryIconController = TextEditingController();
  TextEditingController _categoryFilterController = TextEditingController();
  TextEditingController _subCategoryNameController = TextEditingController();



  FbGlobalConfigAPI fbGlobalConfigAPI = FbGlobalConfigAPI();
  late GlobalConfig globalConfig;

  @override
  void initState() {
    super.initState();
    initializeData();
  }
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: buildCategorySection()),
      Expanded(child: buildFeatureSection()),
      Expanded(child: Container(child: Column(children: [
        Expanded(child: buildBankConfigSection()),
        Expanded(child: buildSubscriptionPackageSection())
      ],),),),

      Expanded(child: Container(child: Column(children: [
        Expanded(child: buildTransactionFeeSection()),
        Expanded(child: buildDeliveryFeeSection()),
        Expanded(child: buildTaxSection()),
        Container(child: buildUpdaterButtonSection(),margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),)
      ],),))
    ],);
  }


  void initializeData() async{
    await fbGlobalConfigAPI.get().then((GlobalConfig value) {
      setState(() {
        globalConfig = value;
      });
    });
  }

  Widget buildCategorySection(){
    return Column(children: [
      Expanded(child: buildCreateCategorySS(),),
      Expanded(child: buildViewCategorySS()),
      Expanded(child: buildCreateSubCategorySS()),
      Expanded(child: buildViewSubCategorySS())
    ],);
  }

  Widget buildCreateCategorySS(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

        TextFormField(
          style: TextStyle(fontSize: 14, color: Colors.red),
          controller: _categoryNameController,

          decoration: InputDecoration(hintText: "category name", labelText: "category name"),
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

        Expanded(child: Container()),
        IconButton(onPressed: (){}, icon: Icon(Icons.create_outlined, color: Colors.green,))

      ],),),),
    );
  }

  Widget buildViewCategorySS(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Column(children: [


      ],),),),
    );
  }

  Widget buildCreateSubCategorySS(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Column(children: [


      ],),),),
    );
  }

  Widget buildViewSubCategorySS(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Column(children: [


      ],),),),
    );
  }


  Widget buildFeatureSection(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Text("category feature"),),),
    );
  }

  Widget buildBankConfigSection(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Text("bank config"),),),
    );
  }

  Widget buildSubscriptionPackageSection(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Text("subscription package"),),),
    );
  }

  Widget buildTransactionFeeSection(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Text("build transaction fee"),),),
    );
  }

  Widget buildDeliveryFeeSection(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Text("build delivery fee"),),),
    );
  }

  Widget buildTaxSection(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Container(child: Center(child: Text("tax section"),),),
    );
  }

  Widget buildUpdaterButtonSection(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Expanded(child: ElevatedButton(onPressed: (){}, child: Text("cancel"),)),
      SizedBox(width: 10,),
      Expanded(child: ElevatedButton(onPressed: (){}, child: Text("update"))),
    ],);
  }
}
