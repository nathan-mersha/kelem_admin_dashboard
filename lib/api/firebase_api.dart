import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:product_approval_dashboard/model/product.dart';
import 'package:product_approval_dashboard/model/shop.dart';
import 'package:uuid/uuid.dart';

class FbProductAPI {
  Future<List<Product>> getUnApprovedProducts() async {
    List<Product> unApprovedProducts = [];
    await FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).where('approved', isEqualTo: false).get().then((QuerySnapshot<Map<String, dynamic>> value) {
      value.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> element) {
        Product product = Product.toModel(element.data());
        unApprovedProducts.add(product);
      });
    });

    print("un approved products count : ${unApprovedProducts.length}");
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
        print(element.data());
        Shop shop = Shop.toModel(element.data());
        shops.add(shop);
      });
    });

    return shops;
  }

  Future getGlobalConfig() async {
    return FirebaseFirestore.instance.collection("globalConfig").doc("snlopoku8ggZD0x7ZDX8").get();
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
