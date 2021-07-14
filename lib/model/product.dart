import 'package:product_approval_dashboard/model/shop.dart';

/// Defines product model
class Product {
  /// Defines key values to extract from a map

  static const String COLLECTION_NAME = "product";

  static const String PRODUCT_ID = "productId";

  static const String TELEGRAM_SHOP_ID = "telegramShopId";
  static const String TELEGRAM_POST_ID = "telegramPostId";
  static const String TELEGRAM_RAW_POST = "telegramRawPost";

  static const String APPROVED = "approved";

  static const String NAME = "name";
  static const String CATEGORY = "category";
  static const String SUB_CATEGORY = "subCategory";
  static const String AUTHOR_OR_MANUFACTURER = "authorOrManufacturer";
  static const String PRICE = "price";
  static const String REGULAR_PRICE = "regularPrice";
  static const String TAG = "tag";
  static const String QUANTITY = "quantity";
  static const String DESCRIPTION = "description";
  static const String RATING = "rating";
  static const String REFERENCE = "reference";
  static const String AVAILABLE_STOCK = "availableStock";
  static const String IMAGE = "image";
  static const String DELIVERABLE = "deliverable";
  static const String META_DATA = "metaData";
  static const String PUBLISHED_STATUS = "publishedStatus";
  static const String SHOP = "shop";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String productId;
  String telegramShopId;
  String telegramPostId;
  String telegramRawPost;
  bool approved;
  String name;
  String category;
  String subCategory;
  String authorOrManufacturer;

  num price;
  num regularPrice;
  List<dynamic> tag;
  String description;
  String quantity;
  num rating;
  String reference;
  num availableStock;
  List<dynamic> image;
  bool deliverable;
  dynamic metaData;
  String publishedStatus;
  Shop shop;
  DateTime firstModified;
  DateTime lastModified;


  Product(
      {
        this.productId = "un-available",
        this.telegramShopId = "un-available",
        this.telegramPostId = "un-available",
        this.telegramRawPost = "un-available",
        this.approved = false,
      this.name = "un-available",
      this.category="un-available",
      this.subCategory="un-available",
      this.authorOrManufacturer="un-available",
      this.price=0,
      this.regularPrice=0,
      this.tag=const [],
      this.quantity = "1",
      this.description="un-available",
      this.rating=0,
      this.reference="un-available",
      this.availableStock=0,
      this.image=const [],
      this.deliverable=false,
      this.metaData,
      this.publishedStatus="un-available",
      required this.shop,
      required this.firstModified,
      required this.lastModified

      });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Product product) {

    return {
      PRODUCT_ID: product.productId,
      TELEGRAM_SHOP_ID : product.telegramShopId,
      TELEGRAM_POST_ID : product.telegramPostId,
      TELEGRAM_RAW_POST : product.telegramRawPost,
      APPROVED :  product.approved,
      NAME: product.name,
      CATEGORY: product.category,
      SUB_CATEGORY: product.subCategory,
      AUTHOR_OR_MANUFACTURER: product.authorOrManufacturer,
      PRICE: product.price,
      REGULAR_PRICE: product.regularPrice,
      TAG: product.tag,
      DESCRIPTION: product.description,
      RATING: product.rating,
      REFERENCE: product.reference,
      AVAILABLE_STOCK: product.availableStock,
      IMAGE: product.image,
      DELIVERABLE: product.deliverable,
      META_DATA: product.metaData,
      PUBLISHED_STATUS: product.publishedStatus,
      SHOP:  Shop.toMap(product.shop),
      FIRST_MODIFIED: product.firstModified.toIso8601String(),
      LAST_MODIFIED: product.lastModified.toIso8601String()
    };
  }

  /// Converts Map to Model
  static Product toModel(dynamic map) {


    try {
      return Product(
          telegramPostId: map[TELEGRAM_POST_ID].toString(),
          telegramShopId: map[TELEGRAM_SHOP_ID].toString(),
          telegramRawPost: map[TELEGRAM_RAW_POST].toString(),
          approved: map[APPROVED],

          productId: map[PRODUCT_ID].toString(),
          name: map[NAME].toString(),
          category: map[CATEGORY].toString(),
          subCategory: map[SUB_CATEGORY].toString(),
          authorOrManufacturer: map[AUTHOR_OR_MANUFACTURER].toString(),
          price: map[PRICE],
          regularPrice: map[REGULAR_PRICE],
          tag: map[TAG],
          description: map[DESCRIPTION].toString(),
          rating: map[RATING] ?? 0.0,
          reference: map[REFERENCE].toString(),
          availableStock: map[AVAILABLE_STOCK],
          image: map[IMAGE],
          deliverable: map[DELIVERABLE],
          metaData: map[META_DATA],
          publishedStatus: map[PUBLISHED_STATUS].toString(),
          shop: map[SHOP] == null ? Shop(firstModified: DateTime.now(), lastModified: DateTime.now()) : Shop.toModel(map[SHOP]),
          firstModified: DateTime.parse(
              map[FIRST_MODIFIED] ?? DateTime.now().toIso8601String()),
          lastModified: DateTime.parse(
              map[LAST_MODIFIED] ?? DateTime.now().toIso8601String()));
    } catch (e) {
      print(e);
      return Product(
        firstModified: DateTime.now(),
          lastModified: DateTime.now(),
          shop: Shop(firstModified: DateTime.now(), lastModified: DateTime.now()),
      );
    }
  }

  /// Changes List of Map to List of Model
  static List<Product> toModelList(List<dynamic> maps) {
    List<Product> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Product> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Product model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
