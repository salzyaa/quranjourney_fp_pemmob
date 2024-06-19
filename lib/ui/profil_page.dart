import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quranjourney/data/models/profil_model.dart'; // Import model profil yang telah dibuat sebelumnya
import 'package:google_fonts/google_fonts.dart';

class MyProfilePage extends StatelessWidget {
  final Profile profileData; // Tambahkan atribut untuk data profil
  const MyProfilePage({Key? key, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Simpan nilai lebar layar ke dalam variabel

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profil'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: profileData.image,
              ),
              SizedBox(height: 10),
              _buildInfoCard(Icons.person, 'Nama Lengkap :', profileData.fullName, screenWidth),
              SizedBox(height: 10),
              _buildInfoCard(Icons.date_range, 'Tempat, Tanggal Lahir :', '${profileData.birthPlace}, ${profileData.birthDate}', screenWidth),
              SizedBox(height: 10),
              _buildInfoCard(Icons.location_on, 'Alamat :', profileData.address, screenWidth),
              SizedBox(height: 10),
              _buildInfoCard(Icons.phone, 'No. HP :', profileData.phoneNumber, screenWidth, onTap: () => _sendWhatsappMessage(profileData.phoneNumber)),
              SizedBox(height: 10),
              _buildInfoCard(Icons.email, 'Email :', profileData.email, screenWidth, onTap: () => _sendEmail(profileData.email)),
              SizedBox(height: 10),
              _buildInfoCard(Icons.link, 'URL Profil Github :', profileData.githubUrl, screenWidth, onTap: () => _openGithubProfile(profileData.githubUrl)),
              SizedBox(height: 10),
              _buildInfoCard(Icons.school, 'Riwayat Pendidikan :', profileData.educationHistory, screenWidth),
              SizedBox(height: 10),
              _buildInfoCard(Icons.star, 'Penghargaan :', profileData.awards, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, double screenWidth, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: const Color(0xFF4E7E95),
        padding: EdgeInsets.all(10),
        width: screenWidth * 0.7, // Menggunakan screenWidth di sini
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendWhatsappMessage(String phoneNumber) async {
    final Uri _whatsappLaunchUri = Uri(
      scheme: 'https',
      path: 'wa.me/$phoneNumber',
    );

    if (await canLaunch(_whatsappLaunchUri.toString())) {
      await launch(_whatsappLaunchUri.toString());
    } else {
      throw 'Could not launch $_whatsappLaunchUri';
    }
  }

  void _sendEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch $_emailLaunchUri';
    }
  }

  void _openGithubProfile(String githubUrl) async {
    if (await canLaunch(githubUrl)) {
      await launch(githubUrl);
    } else {
      throw 'Could not launch $githubUrl';
    }
  }
}
