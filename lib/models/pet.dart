class Pet {
  String? name;
  int? age;
  int? height;
  String? gender;
  String? imageUrl;
  String? subType;
  String? type;

  Pet({
    this.name,
    this.age,
    this.height,
    this.gender,
    this.imageUrl,
    this.subType,
    this.type,
  });

  // Construct Pet from a map (e.g., from Firebase)
  Pet.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    age = map['age'];
    height = map['height'];
    gender = map['gender'];
    imageUrl = map['imageUrl'];
    subType = map['subType'];
    type = map['type'];
  }

  // Convert a Pet object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'gender': gender,
      'imageUrl': imageUrl,
      'subType': subType,
      'type': type,
    };
  }
}
