
import 'image_model.dart';

class ServiceModel {
  final int? id;
  final String? name;
  final String? description;
  final double? dynamicPrice;
  final List<AttributePrice>? attributePrices;
  final ImageModel? image;

  ServiceModel({
    this.id,
    this.name,
    this.description,
    this.dynamicPrice,
    this.attributePrices,
    this.image,
  });

  ServiceModel copyWith({
    int? id,
    String? name,
    String? description,
    double? dynamicPrice,
    ImageModel? image,

    List<AttributePrice>? attributePrices,
  }) => ServiceModel(
    id: id ?? this.id,
    name: name ?? this.name,
    image: image ?? this.image,
    description: description ?? this.description,
    dynamicPrice: dynamicPrice ?? this.dynamicPrice,
    attributePrices: attributePrices ?? this.attributePrices,
  );

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    image: json["image"] == null ? null : ImageModel.fromJson(json["image"]),
    name: json["name"],
    description: json["description"],
    dynamicPrice: json["dynamicPrice"]?.toDouble(),
    attributePrices: json["attributePrices"] == null
        ? []
        : List<AttributePrice>.from(
            json["attributePrices"]!.map((x) => AttributePrice.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "dynamicPrice": dynamicPrice,
    "attributePrices": attributePrices == null
        ? []
        : List<dynamic>.from(attributePrices!.map((x) => x.toJson())),
  };
}

class AttributePrice {
  final int? id;
  final String? bodyType;
  final double? price;

  AttributePrice({this.id, this.bodyType, this.price});

  AttributePrice copyWith({int? id, String? bodyType, double? price}) =>
      AttributePrice(
        id: id ?? this.id,
        bodyType: bodyType ?? this.bodyType,
        price: price ?? this.price,
      );

  factory AttributePrice.fromJson(Map<String, dynamic> json) => AttributePrice(
    id: json["id"],
    bodyType: json["bodyType"],
    price: double.parse(json["price"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bodyType": bodyType,
    "price": price,
  };
}
