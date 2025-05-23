/// Defines shop model
class Shop {
  static const String UN_AVAILABLE = "unAvalialble";

  static const String COLLECTION_NAME = "shop";

  /// Defines key values to extract from a map
  static const String ID = "id";
  static const String TELEGRAM_CHANNEL_ID = "telegramChannelId";
  static const String TELEGRAM_CHANNEL_LINK = "telegramChannelLink";

  static const String SHOP_ID = "shopId";
  static const String USER_ID = "userId";
  static const String NAME = "name";
  static const String PRIMARY_PHONE = "primaryPhone";
  static const String SECONDARY_PHONE = "secondaryPhone";
  static const String EMAIL = "email";
  static const String WEBSITE = "website";
  static const String PHYSICAL_ADDRESS = "physicalAddress";
  static const String CO_ORDINATES = "coOrdinates";
  static const String IS_VIRTUAL = "isVirtual";
  static const String IS_VERIFIED = "isVerified";
  static const String SUBSCRIPTION_PACKAGE = "subscriptionPackage";
  static const String DESCRIPTION = "description";
  static const String CATEGORY = "category";
  static const String RANK = "rank";
  static const String LOGO = "logo";
  static const String CREATED_FROM = "createdFrom";

  static const String TOTAL_APPROVED_PRODUCTS = "totalApprovedProducts";
  static const String TOTAL_DELETIONS = "totalDeletions";
  static const String TOTAL_NONE_PRODUCT_POSTS = "totalNoneProductPosts";
  static const String TOTAL_PRODUCTS = "totalProducts";
  static const String TOTAL_UPDATES = "totalUpdates";
  static const String TOTAL_POSTS = "totalPosts";

  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String id;
  String telegramChannelId;
  String telegramChannelLink;
  String shopId;
  String userId;
  String name;
  String primaryPhone;
  String secondaryPhone;
  String email;
  String website;
  String physicalAddress;
  List<dynamic> coOrdinates;
  bool isVirtual;
  bool isVerified;
  String subscriptionPackage;
  String description;
  String category;
  num rank;
  dynamic logo;
  String createdFrom;

  num totalApprovedProducts;
  num totalDeletions;
  num totalNoneProducts;
  num totalProducts;
  num totalUpdates;
  num totalPosts;

  DateTime firstModified;
  DateTime lastModified;

  Shop(
      {
        this.id = Shop.UN_AVAILABLE,
        this.telegramChannelId = Shop.UN_AVAILABLE,
        this.telegramChannelLink = Shop.UN_AVAILABLE,
        this.shopId = Shop.UN_AVAILABLE,
        this.userId = Shop.UN_AVAILABLE,
        this.name = Shop.UN_AVAILABLE,
        this.primaryPhone = Shop.UN_AVAILABLE,
        this.secondaryPhone = Shop.UN_AVAILABLE,
        this.email = Shop.UN_AVAILABLE,
        this.website = Shop.UN_AVAILABLE,
        this.physicalAddress = Shop.UN_AVAILABLE,
        this.coOrdinates = const [],
        this.isVirtual = false,
        this.isVerified = false,
        this.subscriptionPackage = Shop.UN_AVAILABLE,
        this.description = Shop.UN_AVAILABLE,
        this.category = Shop.UN_AVAILABLE,
        this.rank = 1,
        this.logo = Shop.UN_AVAILABLE,
        this.createdFrom = Shop.UN_AVAILABLE,

        this.totalApprovedProducts = 0,
        this.totalDeletions = 0,
        this.totalNoneProducts = 0,
        this.totalProducts = 0,
        this.totalUpdates = 0,
        this.totalPosts = 0,
        required this.firstModified,
        required this.lastModified
      });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Shop shop) {
    return {
      ID: shop.id,
      TELEGRAM_CHANNEL_ID: shop.telegramChannelId,
      TELEGRAM_CHANNEL_LINK: shop.telegramChannelLink,
      SHOP_ID: shop.shopId,
      USER_ID: shop.userId,
      NAME: shop.name,
      PRIMARY_PHONE: shop.primaryPhone,
      SECONDARY_PHONE: shop.secondaryPhone,
      EMAIL: shop.email,
      WEBSITE: shop.website,
      PHYSICAL_ADDRESS: shop.physicalAddress,
      CO_ORDINATES: shop.coOrdinates,
      IS_VIRTUAL: shop.isVirtual,
      IS_VERIFIED: shop.isVerified,
      SUBSCRIPTION_PACKAGE: shop.subscriptionPackage,
      DESCRIPTION: shop.description,
      CATEGORY: shop.category,
      RANK: shop.rank,
      LOGO: shop.logo,
      CREATED_FROM: shop.createdFrom,
      TOTAL_APPROVED_PRODUCTS: shop.totalApprovedProducts,
      TOTAL_DELETIONS: shop.totalDeletions,
      TOTAL_NONE_PRODUCT_POSTS: shop.totalNoneProducts,
      TOTAL_PRODUCTS: shop.totalProducts,
      TOTAL_UPDATES: shop.totalUpdates,
      TOTAL_POSTS: shop.totalPosts,
      FIRST_MODIFIED: shop.firstModified.toIso8601String(),
      LAST_MODIFIED: shop.lastModified.toIso8601String()
    };
  }

  /// Converts Map to Model
  static Shop toModel(Map<String, dynamic> map) {

    return Shop(
        id: map[ID] ?? Shop.UN_AVAILABLE,
        telegramChannelId: map[TELEGRAM_CHANNEL_ID] ?? Shop.UN_AVAILABLE,
        telegramChannelLink: map[TELEGRAM_CHANNEL_LINK] ?? Shop.UN_AVAILABLE,
        shopId: map[SHOP_ID]?? Shop.UN_AVAILABLE,
        userId: map[USER_ID]?? Shop.UN_AVAILABLE,
        name: map[NAME]?? Shop.UN_AVAILABLE,
        primaryPhone: map[PRIMARY_PHONE]?? Shop.UN_AVAILABLE,
        secondaryPhone: map[SECONDARY_PHONE]?? Shop.UN_AVAILABLE,
        email: map[EMAIL]?? Shop.UN_AVAILABLE,
        website: map[WEBSITE]?? Shop.UN_AVAILABLE,
        physicalAddress: map[PHYSICAL_ADDRESS]?? Shop.UN_AVAILABLE,
        coOrdinates: map[CO_ORDINATES] ?? [0,0],
        isVirtual: map[IS_VIRTUAL] ?? true,
        isVerified: map[IS_VERIFIED] ?? false,
        subscriptionPackage: map[SUBSCRIPTION_PACKAGE]?? Shop.UN_AVAILABLE,
        description: map[DESCRIPTION]?? Shop.UN_AVAILABLE,
        category: map[CATEGORY]?? Shop.UN_AVAILABLE,
        rank: map[RANK] == null ? 1 : num.tryParse(map[RANK].toString()) ?? 1,
        logo: map[LOGO]?? Shop.UN_AVAILABLE,
        createdFrom: map[CREATED_FROM] ?? Shop.UN_AVAILABLE,
        totalApprovedProducts: map[TOTAL_APPROVED_PRODUCTS] ?? 0,
        totalDeletions: map[TOTAL_DELETIONS] ?? 0,
        totalNoneProducts: map[TOTAL_NONE_PRODUCT_POSTS] ?? 0,
        totalProducts: map[TOTAL_PRODUCTS] ?? 0,
        totalUpdates: map[TOTAL_UPDATES] ?? 0,
        totalPosts: map[TOTAL_POSTS] ?? 0,
        firstModified: map[FIRST_MODIFIED] == null ? DateTime.now() : DateTime.parse(map[FIRST_MODIFIED]),
        lastModified: map[LAST_MODIFIED] == null ? DateTime.now() : DateTime.parse(map[LAST_MODIFIED]));
  }

  /// Changes List of Map to List of Model
  static List<Shop> toModelList(List<dynamic> maps) {
    List<Shop> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Shop> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Shop model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
