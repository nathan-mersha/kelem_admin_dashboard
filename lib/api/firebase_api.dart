import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:product_approval_dashboard/model/contact_us.dart';
import 'package:product_approval_dashboard/model/global.dart';
import 'package:product_approval_dashboard/model/product.dart';
import 'package:product_approval_dashboard/model/shop.dart';
import 'package:product_approval_dashboard/model/sync_report.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FbProductAPI {
  Future<List<Product>> getUnApprovedProducts() async {
    List<Product> unApprovedProducts = [];
    await FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).where('approved', isEqualTo: false).limit(50).get().then((QuerySnapshot<Map<String, dynamic>> value) {
      value.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> element) {
        Product product = Product.toModel(element.data());
        unApprovedProducts.add(product);
      });
    });

    return unApprovedProducts;
  }

  Future updateProduct(Product product) {
    return FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).doc(product.productId).update(Product.toMap(product));
  }

  Future deleteProduct(Product product) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    product.image.forEach((imgPath) async {
      await storage.ref(imgPath).delete();
    });

    return FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).doc(product.productId).delete();
  }

  Future deleteProductsOfShop(Shop shop, String deleteType) async {
    late QuerySnapshot<Map<String, dynamic>> snapshot;

    if (deleteType == Product.ALL) {
      snapshot = await FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).where("${Product.SHOP}.${Shop.SHOP_ID}", isEqualTo: shop.shopId).get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection(Product.COLLECTION_NAME)
          .where("${Product.SHOP}.${Shop.SHOP_ID}", isEqualTo: shop.shopId)
          .where(Product.APPROVED, isEqualTo: deleteType == Product.APPROVED ? true : false)
          .get();
    }

    for (var doc in snapshot.docs) {
      Product product = Product.toModel(doc.data());
      deleteProduct(product);
    }
  }
}

class FbShopAPI {
  var uuid = Uuid();
  Future createShop(Shop shop) {
    CollectionReference ref = FirebaseFirestore.instance.collection(Shop.COLLECTION_NAME);

    String id = ref.doc().id;
    shop.id = id;
    shop.shopId = id;

    return ref.doc(id).set(Shop.toMap(shop));
  }

  Future<List<Shop>> getShops() async {
    List<Shop> shops = [];
    await FirebaseFirestore.instance.collection(Shop.COLLECTION_NAME).get().then((QuerySnapshot<Map<String, dynamic>> value) {
      value.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> element) {
        Shop shop = Shop.toModel(element.data());
        shops.add(shop);
      });
    });

    return shops;
  }

  Future updateShop(Shop shop) {
    return FirebaseFirestore.instance.collection(Shop.COLLECTION_NAME).doc(shop.shopId).update(Shop.toMap(shop));
  }

  Future deleteShop(Shop shop) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    storage.ref(shop.logo).delete();
    return FirebaseFirestore.instance.collection(Shop.COLLECTION_NAME).doc(shop.shopId).delete();
  }


}

class FbContactUsAPI {


  Future<List<ContactUs>> getUnResolvedContactUsMessages() async {
    List<ContactUs> contactUsMessages = [];
    await FirebaseFirestore.instance.collection(ContactUs.COLLECTION_NAME).where('resolved', isEqualTo: false).limit(50).get().then((QuerySnapshot<Map<String, dynamic>> value) {
      value.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> element) {
        element.data()["id"] = element.id;
        ContactUs contactUs = ContactUs.toModel(element.data());
        contactUsMessages.add(contactUs);
      });
    });

    return contactUsMessages;
  }

  Future updateContactUsMessages(ContactUs contactUs) {
    return FirebaseFirestore.instance.collection(ContactUs.COLLECTION_NAME).doc(contactUs.id).update(ContactUs.toMap(contactUs));
  }

}

class FbGlobalConfigAPI {
  static const String CONFIG_ID = "snlopoku8ggZD0x7ZDX8";

  Future<GlobalConfig> get() async {
    return FirebaseFirestore.instance.collection(GlobalConfig.COLLECTION_NAME).doc(CONFIG_ID).get().then((DocumentSnapshot value) {
      dynamic data = value.data();

      AdditionalFee additionalFee = AdditionalFee.toModel(data[GlobalConfig.ADDITIONAL_FEE]);
      List<SubscriptionPackage> subscriptionPackages = SubscriptionPackage.toModelList(data[GlobalConfig.SUBSCRIPTION_PACKAGES]);
      FeaturesConfig featuresConfig = FeaturesConfig.toModel(data[GlobalConfig.FEATURES_CONFIG]);
      List<BankConfig> bankConfigs = BankConfig.toModelList(data[GlobalConfig.BANK_CONFIG]);
      List<Category> categories = Category.toModelList(data[GlobalConfig.CATEGORIES]);

      GlobalConfig globalConfig = GlobalConfig(
          globalConfigId: CONFIG_ID,
          additionalFee: additionalFee,
          subscriptionPackages: subscriptionPackages,
          featuresConfig: featuresConfig,
          bankConfigs: bankConfigs,
          categories: categories,
          firstModified: DateTime.parse(data[GlobalConfig.FIRST_MODIFIED]),
          lastModified: DateTime.parse(data[GlobalConfig.LAST_MODIFIED]));

      return globalConfig;
    });
  }

  Future update(GlobalConfig globalConfig) async{
    return FirebaseFirestore.instance.collection(GlobalConfig.COLLECTION_NAME).doc(CONFIG_ID).update(GlobalConfig.toMap(globalConfig));
  }

}

class SyncServerAPI {
  static const url = "https://kelem.et";

  Future<List<SyncReportModel>> getSync() {
    String syncUrl = "$url/server/sync_reports";

    return http.get(Uri.parse(syncUrl), headers: {"Content-Type": "application/json"}).then((http.Response response) {
      dynamic responseBody = jsonDecode(response.body);

      List<SyncReportModel> reports = [];

      responseBody.forEach((element) {
        SyncReportModel report = SyncReportModel.toModel(element);
        reports.add(report);
      });
      return reports;
    }, onError: (err) {
      print(err);
      return [];
    });
  }

  Future<Map<String, dynamic>> getSystemStat(){
    String getStatURL = "$url/server/system_info";

    return http.get(Uri.parse(getStatURL), headers: {"Content-Type": "application/json"}).then((http.Response response) {
      return jsonDecode(response.body);
    }, onError: (err) {
      print(err);
      return [];
    });
  }
}

class TsAPI {
  static const url = "https://kelem.et/server/ts";

  Future indexProduct(Product product) {
    String indexURL = "$url/index/product";
    dynamic body = Product.toMap(product);
    return http.post(Uri.parse(indexURL), headers: {"Content-Type": "application/json"},body: jsonEncode(body)).then((http.Response response) {
      return jsonDecode(response.body);
    }, onError: (err) {
      return {};
    });
  }


  Future indexShop(Shop shop) {
    String indexURL = "$url/index/shop";
    dynamic body = Shop.toMap(shop);
    return http.post(Uri.parse(indexURL), headers: {"Content-Type": "application/json"},body: jsonEncode(body)).then((http.Response response) {
      return jsonDecode(response.body);
    }, onError: (err) {
      return {};
    });
  }

}