class UserModel {
  String? uName;
  String? uPassword;
  String? uEmail;
  String? uNumber;
  String? uAddress;
  String? uProfile;

  UserModel(
      {this.uName,
      this.uPassword,
      this.uEmail,
      this.uNumber,
      this.uAddress,
      this.uProfile});

  //data store in fb is key value pair
  //construct userModel from fb data
  UserModel.fromMap(Map<String, dynamic> map) {
    uName = map["uName"];
    uPassword = map["uPassword"];
    uEmail = map["uEmail"];
    uNumber = map["uNumber"];
    uAddress = map["uAddress"];
    uProfile = map["uProfile"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uName": uName,
      "uPassword": uPassword,
      "uEmail": uEmail,
      "uNumber": uNumber,
      "uAddress": uAddress,
      "uProfile": uProfile
    };
  }
}
