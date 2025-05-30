class DeviceInfoActionDataResponseModel {
  DeviceInfoActionDataResponseModel({
    this.name,
    this.id,
    this.tag,
    this.description,
    this.isActive,
    this.isEditable,
    this.category,
    this.details,
    this.recordGuid,
  });
  factory DeviceInfoActionDataResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DeviceInfoActionDataResponseModel(
      name: json["name"],
      id: json["id"],
      tag: json["tag"],
      description: json["description"],
      isActive: json["isActive"],
      isEditable: json["isEditable"],
      category: json["category"],
      details: json["details"] != null
          ? List<dynamic>.from(json["details"])
          : <dynamic>[],
      recordGuid: json["recordGuid"],
    );
  }
  String? name;
  int? id;
  String? tag;
  String? description;
  bool? isActive;
  bool? isEditable;
  dynamic category;
  List<dynamic>? details;
  String? recordGuid;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name,
      "id": id,
      "tag": tag,
      "description": description,
      "isActive": isActive,
      "isEditable": isEditable,
      "category": category,
      "details": details,
      "recordGuid": recordGuid,
    };
  }
}
