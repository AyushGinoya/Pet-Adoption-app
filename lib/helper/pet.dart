class Pet {
  final String name;
  final int age;
  final int height;
  final String gender;
  final String imageUrl;

  Pet({
    required this.name,
    required this.age,
    required this.height,
    required this.gender,
    required this.imageUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      height: json['height'] ?? 0,
      gender: json['gender'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
