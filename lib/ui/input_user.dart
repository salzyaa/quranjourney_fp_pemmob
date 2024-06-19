import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranjourney/globals.dart';
import 'home_page.dart';

class InputUserPage extends StatefulWidget {
  @override
  _InputUserPageState createState() => _InputUserPageState();
}

class _InputUserPageState extends State<InputUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _navigateToHomePage(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String userName = _nameController.text;
      if (_isInputValid(userName)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userName: userName)),
        );
      }
    }
  }

  bool _isInputValid(String input) {
    // Memeriksa apakah input hanya mengandung huruf
    return RegExp(r'^[a-zA-Z]+$').hasMatch(input);
  }

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
                  'user.png',
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                Text(
                  'Input Nama Pengguna Terlebih Dahulu!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Masukkan Nama Anda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harap mengisi nama terlebih dahulu sebelum lanjut ke home!';
                      }
                      if (!_isInputValid(value)) {
                        return 'Nama pengguna harus berupa huruf (abjad)!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 70),
                ElevatedButton(
                  onPressed: () => _navigateToHomePage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9864D), // Ubah warna latar belakang
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: text
                      ),
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
