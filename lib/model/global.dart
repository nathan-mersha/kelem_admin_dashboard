/// Defines globalConfig model
class GlobalConfig {
  static const String COLLECTION_NAME = "globalConfig";

  /// Defines key values to extract from a map
  static const String GLOBAL_CONFIG_ID = "globalConfigId";
  static const String ADDITIONAL_FEE = "additionalFee";
  static const String SUBSCRIPTION_PACKAGES = "subscriptionPackages";
  static const String FEATURES_CONFIG = "featuresConfig";
  static const String BANK_CONFIG = "bankConfig";
  static const String CATEGORIES = "categories";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String globalConfigId;
  AdditionalFee additionalFee;
  List<SubscriptionPackage> subscriptionPackages;
  FeaturesConfig featuresConfig;
  List<BankConfig> bankConfigs;
  List<Category> categories;
  DateTime firstModified;
  DateTime lastModified;

  GlobalConfig({
    required this.globalConfigId,
    required this.additionalFee,
    required this.subscriptionPackages,
    required this.featuresConfig,
    required this.bankConfigs,
    required this.categories,
    required this.firstModified,
    required this.lastModified,
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(GlobalConfig globalConfig) {
    return {
      GLOBAL_CONFIG_ID: globalConfig.globalConfigId,
      ADDITIONAL_FEE: AdditionalFee.toMap(globalConfig.additionalFee),
      SUBSCRIPTION_PACKAGES: SubscriptionPackage.toMapList(globalConfig.subscriptionPackages),
      FEATURES_CONFIG: FeaturesConfig.toMap(globalConfig.featuresConfig),
      BANK_CONFIG: BankConfig.toMapList(globalConfig.bankConfigs),
      CATEGORIES: Category.toMapList(globalConfig.categories),
      FIRST_MODIFIED: globalConfig.firstModified.toString(),
      LAST_MODIFIED: globalConfig.lastModified.toString()
    };
  }

  /// Converts Map to Model
  static GlobalConfig toModel(Map<String, dynamic> map) {
    return GlobalConfig(
        globalConfigId: map[GLOBAL_CONFIG_ID],
        additionalFee: AdditionalFee.toModel(map[ADDITIONAL_FEE]),
        subscriptionPackages: SubscriptionPackage.toModelList(map[SUBSCRIPTION_PACKAGES]),
        featuresConfig: FeaturesConfig.toModel(map[FEATURES_CONFIG]),
        bankConfigs: BankConfig.toModelList(map[BANK_CONFIG]),
        categories: Category.toModelList(map[CATEGORIES]),
        firstModified: DateTime.parse(map[FIRST_MODIFIED]),
        lastModified: DateTime.parse(map[LAST_MODIFIED]));
  }

  /// Changes List of Map to List of Model
  static List<GlobalConfig> toModelList(List<Map<String, dynamic>> maps) {
    List<GlobalConfig> modelList = [];
    maps.forEach((Map<String, dynamic> map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<GlobalConfig> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((GlobalConfig model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines additionalFee model
class AdditionalFee {
  /// Defines key values to extract from a map
  static const String TRANSACTION_FEE_TYPE = "transactionFeeType"; // Defines calculation type, flat rate or percentage
  static const String TRANSACTION_FEE_VALUE = "transactionFeeValue";
  static const String TAX_FEE_VALUE = "taxFeeValue";
  static const String DELIVERY_FEE_TYPE = "deliveryFeeType"; // Defines calculation type for delivery fee type, km or flat rate
  static const String DELIVERY_FEE_VALUE = "deliveryFeeValue";

  String transactionFeeType;
  num transactionFeeValue;
  num taxFeeValue;
  String deliveryFeeType;
  num deliveryFeeValue;

  AdditionalFee({
    required this.transactionFeeType,
    required this.transactionFeeValue,
    required this.taxFeeValue,
    required this.deliveryFeeType,
    required this.deliveryFeeValue,
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(AdditionalFee additionalFee) {
    return {
      TRANSACTION_FEE_TYPE: additionalFee.transactionFeeType,
      TRANSACTION_FEE_VALUE: additionalFee.transactionFeeValue,
      TAX_FEE_VALUE: additionalFee.taxFeeValue,
      DELIVERY_FEE_TYPE: additionalFee.deliveryFeeType,
      DELIVERY_FEE_VALUE: additionalFee.deliveryFeeValue,
    };
  }

  /// Converts Map to Model
  static AdditionalFee toModel(Map<String, dynamic> map) {
    return AdditionalFee(
      transactionFeeType: map[TRANSACTION_FEE_TYPE],
      transactionFeeValue: map[TRANSACTION_FEE_VALUE],
      taxFeeValue: map[TAX_FEE_VALUE],
      deliveryFeeType: map[DELIVERY_FEE_TYPE],
      deliveryFeeValue: map[DELIVERY_FEE_VALUE],
    );
  }

  /// Changes List of Map to List of Model
  static List<AdditionalFee> toModelList(List<Map<String, dynamic>> maps) {
    List<AdditionalFee> modelList = [];
    maps.forEach((Map<String, dynamic> map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<AdditionalFee> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((AdditionalFee model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines subscriptionPackage model
class SubscriptionPackage {
  /// Defines key values to extract from a map
  static const String NAME = "name";
  static const String FEATURES = "features";
  static const String MONTHLY_PRICE = "monthlyPrice";
  static const String YEARLY_PRICE = "yearlyPrice";

  String name;
  List<dynamic> features;
  num monthlyPrice;
  num yearlyPrice;

  SubscriptionPackage({
    required this.name,
    required this.features,
    required this.monthlyPrice,
    required this.yearlyPrice,
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(SubscriptionPackage subscriptionPackage) {

    return {
      NAME: subscriptionPackage.name,
      FEATURES: subscriptionPackage.features,
      MONTHLY_PRICE: subscriptionPackage.monthlyPrice,
      YEARLY_PRICE: subscriptionPackage.yearlyPrice,
    };
  }

  /// Converts Map to Model
  static SubscriptionPackage toModel(dynamic map) {
    return SubscriptionPackage(
      name: map[NAME],
      features: map[FEATURES],
      monthlyPrice: map[MONTHLY_PRICE],
      yearlyPrice: map[YEARLY_PRICE],
    );
  }

  /// Changes List of Map to List of Model
  static List<SubscriptionPackage> toModelList(List<dynamic> maps) {
    List<SubscriptionPackage> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<SubscriptionPackage> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((SubscriptionPackage model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines featuresConfig model
class FeaturesConfig {
  /// Defines key values to extract from a map
  static const String BUY_CREDIT = "buyCredit";
  static const String CLAIM_GIFT = "claimGift";
  static const String WALLET = "wallet";
  static const String TRANSACTIONS = "transactions";
  static const String SHOP = "shop";
  static const String WISH_LIST = "wishList";
  static const String NEWS = "news";
  static const String ABOUT_US = "aboutUs";
  static const String ORDER = "order";
  static const String FORCE_NEWS_ON_HOME = "forceNewsOnHome";
  static const String BEST_SELLERS = "bestSellers";
  static const String CASH_OUT = "cashOut";
  static const String SHOP_DETAIL = "shopDetail";
  static const String SHOP_INFORMATION = "shopInformation";
  static const String PAYMENT_METHOD_CASH_ON_DELIVERY = "paymentMethodCashOnDelivery";
  static const String PAYMENT_METHOD_KELEM_WALLET = "paymentMethodKelemWallet";
  static const String PAYMENT_METHOD_HISAB_WALLET = "paymentMethodHisabWallet";
  static const String CASH_OUT_SUPPORT_BANKS = "cashOutSupportBanks";
  static const String TIN = "tin";

  bool claimGift;
  bool aboutUs;
  bool bestSellers;
  bool buyCredit;
  bool cashOut;
  bool forceNewsOnHome;
  bool news;
  bool order;
  bool paymentMethodCashOnDelivery;
  bool paymentMethodHisabWallet;
  bool paymentMethodKelemWallet;
  bool shopDetail;
  bool shopInformation;
  bool tin;
  bool transactions;
  bool shop;
  bool wallet;
  bool wishList;


  List<dynamic> cashOutSupportBanks;



  FeaturesConfig({
    required this.claimGift,
    required this.buyCredit,
    required this.wallet,
    required this.transactions,
    required this.shop,
    required this.wishList,
    required this.news,
    required this.aboutUs,
    required this.order,
    required this.forceNewsOnHome,
    required this.bestSellers,
    required this.cashOut,
    required this.shopDetail,
    required this.shopInformation,
    required this.paymentMethodCashOnDelivery,
    required this.paymentMethodKelemWallet,
    required this.paymentMethodHisabWallet,
    required this.cashOutSupportBanks,
    required this.tin,
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(FeaturesConfig featuresConfig) {
    return {
      CLAIM_GIFT:  featuresConfig.claimGift,
      BUY_CREDIT: featuresConfig.buyCredit,
      WALLET: featuresConfig.wallet,
      TRANSACTIONS: featuresConfig.transactions,
      SHOP: featuresConfig.shop,
      WISH_LIST: featuresConfig.wishList,
      NEWS: featuresConfig.news,
      ABOUT_US: featuresConfig.aboutUs,
      ORDER: featuresConfig.order,
      FORCE_NEWS_ON_HOME: featuresConfig.forceNewsOnHome,
      BEST_SELLERS: featuresConfig.bestSellers,
      CASH_OUT: featuresConfig.cashOut,
      SHOP_DETAIL: featuresConfig.shopDetail,
      SHOP_INFORMATION: featuresConfig.shopInformation,
      PAYMENT_METHOD_CASH_ON_DELIVERY: featuresConfig.paymentMethodCashOnDelivery,
      PAYMENT_METHOD_KELEM_WALLET: featuresConfig.paymentMethodKelemWallet,
      PAYMENT_METHOD_HISAB_WALLET: featuresConfig.paymentMethodHisabWallet,
      CASH_OUT_SUPPORT_BANKS: featuresConfig.cashOutSupportBanks,
      TIN: featuresConfig.tin,
    };
  }

  /// Converts Map to Model
  static FeaturesConfig toModel(Map<String, dynamic> map) {
    return FeaturesConfig(
      claimGift: map[CLAIM_GIFT],
      buyCredit: map[BUY_CREDIT],
      wallet: map[WALLET],
      transactions: map[TRANSACTIONS],
      shop: map[SHOP],
      wishList: map[WISH_LIST],
      news: map[NEWS],
      aboutUs: map[ABOUT_US],
      order: map[ORDER],
      forceNewsOnHome: map[FORCE_NEWS_ON_HOME],
      bestSellers: map[BEST_SELLERS],
      cashOut: map[CASH_OUT],
      shopDetail: map[SHOP_DETAIL],
      shopInformation: map[SHOP_INFORMATION],
      paymentMethodCashOnDelivery: map[PAYMENT_METHOD_CASH_ON_DELIVERY],
      paymentMethodKelemWallet: map[PAYMENT_METHOD_KELEM_WALLET],
      paymentMethodHisabWallet: map[PAYMENT_METHOD_HISAB_WALLET],
      cashOutSupportBanks: map[CASH_OUT_SUPPORT_BANKS],
      tin: map[TIN],
    );
  }

  /// Changes List of Map to List of Model
  static List<FeaturesConfig> toModelList(List<Map<String, dynamic>> maps) {
    List<FeaturesConfig> modelList = [];
    maps.forEach((Map<String, dynamic> map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<FeaturesConfig> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((FeaturesConfig model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines dialling pattern
class BankConfig {
  /// Defines key values to extract from a map
  static const String BANK_NAME = "bankName";
  static const String BANK_CODE = "bankCode";
  static const String ICON = "icon";
  static const String DEPOSIT_TO_DIALLING_PATTERN = "depositToDiallingPattern";
  static const String KELEM_BANK_ACCOUNT = "kelemBankAccount";

  String bankName;
  String bankCode;
  String icon;
  String depositToDiallingPattern;
  String kelemBankAccount;

  BankConfig({
    required this.bankName,
    required this.bankCode,
    required this.icon,

    required this.depositToDiallingPattern,
    required this.kelemBankAccount,
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(BankConfig bankConfig) {
    return {
      BANK_NAME: bankConfig.bankName,
      BANK_CODE: bankConfig.bankCode,
      ICON : bankConfig.icon,
      DEPOSIT_TO_DIALLING_PATTERN: bankConfig.depositToDiallingPattern,
      KELEM_BANK_ACCOUNT: bankConfig.kelemBankAccount,
    };
  }

  /// Converts Map to Model
  static BankConfig toModel(Map<String, dynamic> map) {
    return BankConfig(
      bankName: map[BANK_NAME],
      bankCode: map[BANK_CODE],
      icon: map[ICON],
      depositToDiallingPattern: map[DEPOSIT_TO_DIALLING_PATTERN],
      kelemBankAccount: map[KELEM_BANK_ACCOUNT],
    );
  }

  /// Changes List of Map to List of Model
  static List<BankConfig> toModelList(List<dynamic> maps) {
    List<BankConfig> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<BankConfig> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((BankConfig model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines items categories
class Category {
  /// Defines key values to extract from a map
  static const String NAME = "name";
  static const String ICON = "icon";
  static const String SUB_CATEGORIES = "subCategories";

  String name;
  String icon;
  List<dynamic> subCategories;

  /// Category constructor
  Category({
    required this.name,
    required this.icon,
    required this.subCategories,
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Category category) {
    return {
      NAME: category.name,
      ICON: category.icon,
      SUB_CATEGORIES: category.subCategories,
    };
  }

  /// Converts Map to Model
  static Category toModel(dynamic map) {
    return Category(
      name: map[NAME],
      icon: map[ICON] == null ? "some icon" : map[ICON],
      subCategories: map[SUB_CATEGORIES] == null ? [] : map[SUB_CATEGORIES],
    );
  }

  /// Changes List of Map to List of Model
  static List<Category> toModelList(dynamic maps) {
    List<Category> modelList = [];

    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Category> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Category model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}


