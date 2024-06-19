import 'package:flutter/material.dart';

class Profile {
  final String fullName;
  final String birthPlace;
  final String birthDate;
  final String address;
  final String phoneNumber;
  final String email;
  final String githubUrl;
  final String educationHistory;
  final String awards;
  final AssetImage image;

  Profile({
    required this.fullName,
    required this.birthPlace,
    required this.birthDate,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.githubUrl,
    required this.educationHistory,
    required this.awards,
    required this.image,
  });
}


final Profile arizaldiProfile = Profile(
  fullName: 'Muhammad Arizaldi Eka Prasetya',
  birthPlace: 'Jombang',
  birthDate: '04 Desember 2003',
  address: 'Rejoso Ngumpul Jogoroto Jombang',
  phoneNumber: '085746072075',
  email: '22082010074@student.upnjatim.ac.id',
  githubUrl: 'https://github.com/Arizaldi123',
  educationHistory: 'MIN 4 Jombang\nMTsN 2 Jombang\nSMK Telekomunikasi Darul Ulum Jombang',
  awards: '-------------',
  image: const AssetImage('assets/profil_arizaldi.jpeg'),
);

final Profile salsaProfile = Profile(
  fullName: 'Salsabila Putri Azzahra',
  birthPlace: 'Surabaya',
  birthDate: '26 Desember 2003',
  address: 'Jl. Kebonsari No. 3C Surabaya',
  phoneNumber: '085784167798',
  email: '22082010079@student.upnjatim.ac.id',
  githubUrl: 'https://github.com/salzyaa',
  educationHistory: 'SDN Jambangan 1 Surabaya\nSMP Negeri 21 Surabaya\nSMA Negeri 18 Surabaya',
  awards: '-------------',
  image: const AssetImage('assets/profil_salsa.jpeg'),
);
