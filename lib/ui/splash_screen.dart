import 'package:flutter/material.dart';
import 'package:quranjourney/globals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'input_user.dart';  // Tambahkan ini

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'quran2.png',
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 10),
                Text(
                  'Qur\'anJourney',
                  style: GoogleFonts.stardosStencil(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Baca Al Qur\'an dengan mudah',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: text,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the InputUserPage when button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InputUserPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9864D), // Ubah warna latar belakang
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    child: Text(
                      'Baca Sekarang',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w400, color: text),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
