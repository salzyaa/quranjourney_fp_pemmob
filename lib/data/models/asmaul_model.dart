class AsmaulHusnaModel {
  final String id;
  final String arab;
  final String latin;
  final String indo;

  AsmaulHusnaModel({
    required this.id,
    required this.arab,
    required this.latin,
    required this.indo,
  });

  factory AsmaulHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaModel(
      id: json["id"].toString(),
      arab: json["arab"],
      latin: json["latin"],
      indo: json["indo"],
    );
  }
}
