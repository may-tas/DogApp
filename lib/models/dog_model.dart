import 'dart:convert';

class Dog {
  final int id;
  final String name;
  final String breedGroup;
  final String size;
  final String lifespan;
  final String origin;
  final String temperament;
  final List<String> colors;
  final String description;
  final String image;

  Dog({
    required this.id,
    required this.name,
    required this.breedGroup,
    required this.size,
    required this.lifespan,
    required this.origin,
    required this.temperament,
    required this.colors,
    required this.description,
    required this.image,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as int,
      name: json['name'] as String,
      breedGroup: json['breed_group'] as String,
      size: json['size'] as String,
      lifespan: json['lifespan'] as String,
      origin: json['origin'] as String,
      temperament: json['temperament'] as String,
      colors: json['colors'] is String
          ? List<String>.from(jsonDecode(
              json['colors'] as String)) // Decode if stored as JSON String
          : List<String>.from(
              json['colors']), // If already a List, use it directly
      description: json['description'] as String,
      image:
          "https://images.dog.ceo/breeds/retriever-golden/n02099601_4933.jpg",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed_group': breedGroup,
      'size': size,
      'lifespan': lifespan,
      'origin': origin,
      'temperament': temperament,
      'colors': jsonEncode(colors),
      'description': description,
      'image': image,
    };
  }

  // For database operations
  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog.fromJson(map);
  }
}
