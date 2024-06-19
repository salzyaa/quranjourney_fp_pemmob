import 'package:flutter/material.dart';
import 'package:quranjourney/data/models/surat_model.dart';

class KeteranganSuratPage extends StatelessWidget {
  final SuratModel surat;

  const KeteranganSuratPage({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Keterangan Surat ${surat.namaLatin}', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF4E7E95),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          radius: 35.0,
                          child: Icon(
                            Icons.info,
                            size: 50.0,
                            color: Color(0xFF4E7E95),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Detail Surah ${surat.namaLatin}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  Text('Arti Surah : ${surat.arti}'),
                  SizedBox(height: 8.0),
                  Text('Jumlah Ayat : ${surat.jumlahAyat} Ayat'),
                  SizedBox(height: 8.0),
                  Text('No Surah : ${surat.nomor}'),
                  SizedBox(height: 8.0),
                  Text('Tempat Turun : ${surat.tempatTurun == TempatTurun.MEKAH ? 'Mekah' : 'Madinah'}'),
                  SizedBox(height: 16.0),
                  Text(
                    'Keterangan Surah :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    surat.deskripsi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
