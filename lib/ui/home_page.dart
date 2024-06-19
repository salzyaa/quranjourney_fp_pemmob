import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quranjourney/globals.dart';
import 'package:quranjourney/ui/surat_page.dart';
import 'package:quranjourney/ui/asmaulhusna_page.dart';
import 'package:quranjourney/ui/doa_page.dart';
import 'package:quranjourney/ui/dzikir_page.dart';
import 'package:quranjourney/ui/bookmark_page.dart';
import 'package:quranjourney/ui/favorit_page.dart';
import 'package:quranjourney/ui/profil_page.dart';
import 'package:quranjourney/data/models/profil_model.dart';

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  List<Widget> get _widgetOptions {
    return <Widget>[
      Scaffold(
        appBar: AppBar(
          backgroundColor: background,
          centerTitle: true,
          title: const Text(
            'Qur\'anJourney',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: HomePageContent(userName: widget.userName),
      ),
      BookmarkPage(),
      FavoritPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: background,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil Kelompok',
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.0),
                   Padding(
                    padding: const EdgeInsets.only(top: 6.0), 
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 22, 
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profil_arizaldi.jpeg'),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Profil Arizaldi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfilePage(profileData: arizaldiProfile)),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profil_salsa.jpeg'),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Profil Salsabila',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfilePage(profileData: salsaProfile)),
                );
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 34, 75, 94),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final String userName;

  HomePageContent({required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assalamu\'alaikum, $userName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          CarouselSlider(
            items: [
              _buildCarouselItem(
                'Selamat Datang di Aplikasi Qur\'anJourney',
                AssetImage('assets/logo_quran.png'),
              ),
              _buildCarouselItem(
                'Bacalah Al-Qur\'an, karena sesungguhnya ia akan menjadi syafaat bagi para pembacanya di hari kiamat (HR. Muslim)',
                AssetImage('lantern.png'),
              ),
              _buildCarouselItem(
                'Orang yang membaca Al-Qur\'an dan ia mahir membacanya, maka kelak ia akan bersama para malaikat yang mulia lagi taat kepada Allah (HR. Bukhari Muslim)',
                AssetImage('lantern2.png'),
              ),
            ],
            options: CarouselOptions(
              height: 200,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              onPageChanged: (index, reason) {},
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [0, 1].map((index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0 ? Colors.white : Colors.grey,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Menu layout adjustment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuButton('quran.png', 'Al Qur\'an', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuratPage()),
                );
              }),
              _buildMenuButton('doa.png', 'Doa-Doa', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoaPage()),
                );
              }),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuButton('asma_allah.png', 'Asmaul Husna', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AsmaulHusnaPage()),
                );
              }),
              _buildMenuButton('dzikir.png', 'Dzikir', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DzikirPage()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String text, AssetImage? image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: background,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: text.startsWith('Selamat') ? TextAlign.left : TextAlign.justify,
                style: TextStyle(
                  fontSize: text.startsWith('Selamat') ? 20 : 15, 
                  fontWeight: text.startsWith('Selamat') ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            if (image != null) ...[
              SizedBox(width: 20),
              Image(image: image, fit: BoxFit.contain, height: 100),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180, // Adjust width as needed
        height: 160,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 60),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}