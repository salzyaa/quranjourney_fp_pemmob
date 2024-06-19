import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quranjourney/data/models/asmaul_model.dart';
import 'package:quranjourney/data/models/doa_model.dart';
import 'package:dartz/dartz.dart';
import 'package:quranjourney/data/models/surat_detail_model.dart';
import 'package:quranjourney/data/models/surat_model.dart';

class ApiService {
  final String baseUrl = 'https://api.dikiotang.com/quran/asma';
  final String doaApiUrl1 = 'https://api.dikiotang.com/doa';
  final String doaApiUrl2 = 'https://islamic-api-zhirrr.vercel.app/api/doaharian';
  final http.Client client;

  ApiService({required this.client});

  Future<List<AsmaulHusnaModel>> fetchAsmaulHusna() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)["data"];
      final List<AsmaulHusnaModel> asmaulHusna = jsonResponse
          .map((json) => AsmaulHusnaModel.fromJson(json))
          .toList();
      return asmaulHusna;
    } else {
      throw Exception('Failed to load Asmaul Husna');
    }
  }

  Future<List<DoaModel>> fetchDoaFromApi1() async {
    final response = await http.get(Uri.parse(doaApiUrl1));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)["data"];
      final List<DoaModel> doaList = jsonResponse
          .map((json) => DoaModel.fromJsonApi1(json))
          .toList();
      return doaList;
    } else {
      throw Exception('Failed to load Doa from API 1');
    }
  }

Future<List<DoaModel>> fetchDoaFromApi2() async {
  final response = await http.get(Uri.parse(doaApiUrl2));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body)["data"];
    final List<DoaModel> doaList = jsonResponse
        .map((json) => DoaModel.fromJsonApi2(json))
        .toList();
    return doaList;
  } else {
    throw Exception('Failed to load Doa from API 2');
  }
}

Future<Either<String, List<SuratModel>>> getAllSurat() async {
    try {
      final response =
          await client.get(Uri.parse('https://equran.id/api/surat'));
      return Right(List<SuratModel>.from(
        jsonDecode(response.body).map(
          (x) => SuratModel.fromJson(x),
        ),
      ).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SuratDetailModel>> getDetailSurat(
      int nomorSurat) async {
    try {
      final response = await client
          .get(Uri.parse('https://equran.id/api/surat/$nomorSurat'));
      return Right(SuratDetailModel.fromJson(jsonDecode(response.body)));
    } catch (e) {
      return Left(e.toString());
    }
  }
}

