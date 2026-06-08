class UserModel {
  final int id;
  final String username;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: int.parse(json["id"].toString()),
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}