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
  static const String LOGO = "logo";
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
  dynamic logo;
  DateTime firstModified;
  DateTime lastModified;

  Shop(
      {this.id = Shop.UN_AVAILABLE,
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
      this.logo = Shop.UN_AVAILABLE,
      required this.firstModified,
      required this.lastModified});

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
      LOGO: shop.logo,
      FIRST_MODIFIED: shop.firstModified.toIso8601String(),
      LAST_MODIFIED: shop.lastModified.toIso8601String()
    };
  }

  /// Converts Map to Model
  static Shop toModel(Map<String, dynamic> map) {

    print("---------------------------------- ");
    print(map[ID]);
    print(map[TELEGRAM_CHANNEL_ID]);
    print(map[TELEGRAM_CHANNEL_LINK]);
    print(map[SHOP_ID]);
    print(map[USER_ID]);
    print(map[NAME]);
    print(map[PRIMARY_PHONE]);
    print(map[SECONDARY_PHONE]);
    print(map[EMAIL]);
    print(map[WEBSITE]);
    print(map[PHYSICAL_ADDRESS]);
    print(map[CO_ORDINATES]);
    print(map[IS_VIRTUAL]);
    print(map[IS_VERIFIED]);
    print(map[SUBSCRIPTION_PACKAGE]);
    print(map[DESCRIPTION]);
    print(map[CATEGORY]);
    print(map[LOGO]);
    print(map[FIRST_MODIFIED]);
    print(map[LAST_MODIFIED]);
    try {
      return Shop(
          id: map[ID],
          telegramChannelId: map[TELEGRAM_CHANNEL_ID],
          telegramChannelLink: map[TELEGRAM_CHANNEL_LINK],
          shopId: map[SHOP_ID],
          userId: map[USER_ID],
          name: map[NAME],
          primaryPhone: map[PRIMARY_PHONE],
          secondaryPhone: map[SECONDARY_PHONE],
          email: map[EMAIL],
          website: map[WEBSITE],
          physicalAddress: map[PHYSICAL_ADDRESS],
          coOrdinates: map[CO_ORDINATES],
          isVirtual: map[IS_VIRTUAL],
          isVerified: map[IS_VERIFIED],
          subscriptionPackage: map[SUBSCRIPTION_PACKAGE],
          description: map[DESCRIPTION],
          category: map[CATEGORY],
          logo: map[LOGO],
          firstModified: map[FIRST_MODIFIED] == null ? DateTime.now() : DateTime.parse(map[FIRST_MODIFIED]),
          lastModified: map[LAST_MODIFIED] == null ? DateTime.now() : DateTime.parse(map[LAST_MODIFIED]));
    } catch (e) {
      print(e);
      return Shop(firstModified: DateTime.now(), lastModified: DateTime.now());
    }
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
