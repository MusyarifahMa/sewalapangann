class BookingModel {
  final int id;
  final String namaLapangan;
  final String tanggal;
  final String jam;
  final String status;

  BookingModel({
    required this.id,
    required this.namaLapangan,
    required this.tanggal,
    required this.jam,
    required this.status,
  });

  factory BookingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingModel(
      id: int.parse(json["id"].toString()),
      namaLapangan:
          json["nama_lapangan"] ?? "",
      tanggal:
          json["tanggal"] ?? "",
      jam:
          json["jam"] ?? "",
      status:
          json["status"] ?? "",
    );
  }
}