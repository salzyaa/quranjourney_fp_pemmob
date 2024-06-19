class DoaModel {
  final String judul;
  final String arab;
  final String indo;

  DoaModel({
    required this.judul,
    required this.arab,
    required this.indo,
  });

  factory DoaModel.fromJsonApi1(Map<String, dynamic> json) {
    return DoaModel(
      judul: json['judul'] ?? '',
      arab: json['arab'] ?? '',
      indo: json['indo'] ?? '',
    );
  }

  factory DoaModel.fromJsonApi2(Map<String, dynamic> json) {
    return DoaModel(
      judul: json['title'] ?? '',
      arab: json['arabic'] ?? '',
      indo: json['translation'] ?? '',
    );
  }

  get title => null;

  get arabic => null;

  get translation => null;

  get latin => null;
}
