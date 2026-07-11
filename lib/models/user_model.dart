class UserModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String tanggalLahir;
  final String gender;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.tanggalLahir,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json["id"].toString()),
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      phone: json["telepon"] ?? json["phone"] ?? "",
      tanggalLahir: json["tanggal_lahir"] ?? json["tanggalLahir"] ?? "",
      gender: json["gender"] ?? "",
    );
  }
}
