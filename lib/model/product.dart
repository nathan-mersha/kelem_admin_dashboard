import 'package:product_approval_dashboard/model/shop.dart';

/// Defines product model
class Product {
  /// Defines key values to extract from a map
  static const String UN_AVAILABLE = "un-available";

  static const String COLLECTION_NAME = "product";

  static const String PRODUCT_ID = "productId";

  static const String TELEGRAM_SHOP_ID = "telegramShopId";
  static const String TELEGRAM_POST_ID = "telegramPostId";
  static const String TELEGRAM_RAW_POST = "telegramRawPost";

  static const String APPROVED = "approved";
  static const String UN_APPROVED = "un-approved"; // note : used in deleting products as an enum, not used in map
  static const String ALL = "all"; // note : used in deleting products as an enum, not used in map

  static const String NAME = "name";
  static const String KEYWORDS = "keywords";
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
  List<dynamic> keywords;
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
      {this.productId = UN_AVAILABLE,
      this.telegramShopId = UN_AVAILABLE,
      this.telegramPostId = UN_AVAILABLE,
      this.telegramRawPost = UN_AVAILABLE,
      this.approved = false,
      this.name = UN_AVAILABLE,
      this.keywords = const [],
      this.category = UN_AVAILABLE,
      this.subCategory = UN_AVAILABLE,
      this.authorOrManufacturer = UN_AVAILABLE,
      this.price = 0,
      this.regularPrice = 0,
      this.tag = const [],
      this.quantity = "1",
      this.description = UN_AVAILABLE,
      this.rating = 0,
      this.reference = UN_AVAILABLE,
      this.availableStock = 0,
      this.image = const [],
      this.deliverable = false,
      this.metaData,
      this.publishedStatus = UN_AVAILABLE,
      required this.shop,
      required this.firstModified,
      required this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Product product) {
    return {
      PRODUCT_ID: product.productId,
      TELEGRAM_SHOP_ID: product.telegramShopId,
      TELEGRAM_POST_ID: product.telegramPostId,
      TELEGRAM_RAW_POST: product.telegramRawPost,
      APPROVED: product.approved,
      NAME: product.name,
      KEYWORDS: product.keywords,
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
      SHOP: Shop.toMap(product.shop),
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
          keywords: map[KEYWORDS],
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
          firstModified: DateTime.parse(map[FIRST_MODIFIED] ?? DateTime.now().toIso8601String()),
          lastModified: DateTime.parse(map[LAST_MODIFIED] ?? DateTime.now().toIso8601String()));
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
