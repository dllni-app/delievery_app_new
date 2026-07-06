
class SectorModel {
  final int? id;
  final String? name;
  final int? cityId;

  SectorModel({
    this.id,
    this.name,
    this.cityId,
  });

  SectorModel copyWith({
    int? id,
    String? name,
    int? cityId,
  }) =>
      SectorModel(
        id: id ?? this.id,
        name: name ?? this.name,
        cityId: cityId ?? this.cityId,
      );

  factory SectorModel.fromJson(Map<String, dynamic> json) => SectorModel(
    id: json["id"],
    name: json["name"],
    cityId: json["cityId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cityId": cityId,
  };
}
