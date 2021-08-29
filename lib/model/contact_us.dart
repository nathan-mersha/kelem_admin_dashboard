/// Defines ContactUs model
class ContactUs {
  static const String COLLECTION_NAME = "contactUs";

  static const String UN_AVAILABLE = "unAvailable";

  /// Defines key values to extract from a map
  static const String ID = "id";
  static const String FROM = "from";
  static const String TITLE = "title";
  static const String BODY = "body";
  static const String RESOLVED = "resolved";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String id;
  String from;
  String title;
  String body;
  bool resolved;
  DateTime firstModified;
  DateTime lastModified;

  ContactUs({

    this.id = ContactUs.UN_AVAILABLE,
    this.from = ContactUs.UN_AVAILABLE,
    this.title = ContactUs.UN_AVAILABLE,
    this.body = ContactUs.UN_AVAILABLE,
    this.resolved = false,
    required this.firstModified,
    required this.lastModified
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(ContactUs contactUs) {
    return {ID: contactUs.id, FROM: contactUs.from, TITLE: contactUs.title, BODY: contactUs.body, RESOLVED: contactUs.resolved, FIRST_MODIFIED: contactUs.firstModified.toIso8601String(), LAST_MODIFIED: contactUs.lastModified.toIso8601String()};
  }

  /// Converts Map to Model
  static ContactUs toModel(dynamic map) {
    return ContactUs(
        id: map[ID],
        from: map[FROM],
        title: map[TITLE],
        body: map[BODY],
        resolved: map[RESOLVED],
        firstModified: DateTime.parse(map[FIRST_MODIFIED] ?? DateTime.now().toIso8601String()),
        lastModified: DateTime.parse(map[LAST_MODIFIED] ?? DateTime.now().toIso8601String()));
  }

  /// Changes List of Map to List of Model
  static List<ContactUs> toModelList(List<dynamic> maps) {
    List<ContactUs> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<ContactUs> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((ContactUs model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
