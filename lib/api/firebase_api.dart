import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:product_approval_dashboard/model/product.dart';

class FirebaseAPI {
  Future<List<Product>> getUnApprovedProducts() async {
    List<Product> unApprovedProducts = [];
    await FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).where('approved', isEqualTo: false).get().then((QuerySnapshot<Map<String, dynamic>> value) {
      print(value);

      value.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> element) {
        Product product = Product.toModel(element.data());
        unApprovedProducts.add(product);
      });
    });

    return unApprovedProducts;
  }

  Future deleteProduct(Product product) async {
    return FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).doc(product.productId).delete();
  }

  Future updateProduct(Product product) {
    return FirebaseFirestore.instance.collection(Product.COLLECTION_NAME).doc(product.productId).update(Product.toMap(product));
  }
}
