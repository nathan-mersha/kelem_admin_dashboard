import 'package:product_approval_dashboard/model/shop.dart';

/// Defines shop model
class SyncReportModel {

  static const String COLLECTION_NAME = "syncReport";

  static const String SHOP = "shop";
  static const String INITIATED = "initiated";
  static const String CREATED = "created";
  static const String UPDATED = "updated";
  static const String REMOVED = "removed";
  static const String IGNORED = "ignored";
  static const String TOTAL_ANALYZED = "totalAnalyzed";
  static const String FIRST_MODIFIED = "first_modified";
  static const String LAST_MODIFIED = "lastModified";

  dynamic shop;
  String initiated;
  num created;
  num updated;
  num removed;
  num ignored;
  num totalAnalyzed;
  DateTime firstModified;
  DateTime lastModified;

  SyncReportModel(
      {
        required this.shop,
        this.initiated = "automatic",
        this.created = 0,
        this.updated = 0,
        this.removed = 0,
        this.ignored = 0,
        this.totalAnalyzed = 0,
        required this.firstModified,
        required this.lastModified
      });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(SyncReportModel syncReportModel) {
    return {
      SHOP: syncReportModel.shop,
      INITIATED: syncReportModel.initiated,
      CREATED : syncReportModel.created,
      UPDATED : syncReportModel.updated,
      REMOVED : syncReportModel.removed,
      IGNORED : syncReportModel.ignored,
      TOTAL_ANALYZED : syncReportModel.totalAnalyzed,
      FIRST_MODIFIED: syncReportModel.firstModified.toIso8601String(),
      LAST_MODIFIED: syncReportModel.lastModified.toIso8601String()
    };
  }

  /// Converts Map to Model
  static SyncReportModel toModel(Map<String, dynamic> map) {
    print(map[FIRST_MODIFIED]);
    print(map[LAST_MODIFIED]);
    try {
      return SyncReportModel(
          shop: map[SHOP],
          initiated: map[INITIATED] == null ? "automatic" : map[INITIATED],
          created: map[CREATED],
          updated: map[UPDATED],
          removed: map[REMOVED],
          ignored: map[IGNORED],
          firstModified: map[FIRST_MODIFIED] == null ? DateTime.now() : DateTime.parse(map[FIRST_MODIFIED]),
          lastModified: map[LAST_MODIFIED] == null ? DateTime.now() : DateTime.parse(map[LAST_MODIFIED]));
    } catch (e) {
      return SyncReportModel(initiated: "automatic",shop: Shop(firstModified: DateTime.now(), lastModified: DateTime.now()), firstModified: DateTime.now(), lastModified: DateTime.now());
    }
  }

  /// Changes List of Map to List of Model
  static List<SyncReportModel> toModelList(List<dynamic> maps) {
    List<SyncReportModel> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<SyncReportModel> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((SyncReportModel model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
