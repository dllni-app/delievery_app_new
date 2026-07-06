class PackageModel {
  final int? id;
  final String? name;
  final String? description;
  final int? numberOfWashes;
  final int? price;

  PackageModel({
    this.id,
    this.name,
    this.description,
    this.numberOfWashes,
    this.price,
  });

  PackageModel copyWith({
    int? id,
    String? name,
    String? description,
    int? numberOfWashes,
    int? price,
  }) =>
      PackageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        numberOfWashes: numberOfWashes ?? this.numberOfWashes,
        price: price ?? this.price,
      );

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    numberOfWashes: json["numberOfWashes"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "number_of_washes": numberOfWashes,
    "price": price,
  };
}
