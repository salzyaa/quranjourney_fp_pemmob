import 'package:flutter/material.dart';
import 'package:quranjourney/data/models/asmaul_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quranjourney/data/models/doa_model.dart';

class FavoritPage extends StatefulWidget {
  @override
  _FavoritPageState createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  late SharedPreferences prefs;
  List<DoaModel> favoriteDoaList = [];
  List<AsmaulHusnaModel> favoriteAsmaulHusnaList = [];

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _loadFavoriteDoa();
    _loadFavoriteAsmaulHusna();
  }

  void _loadFavoriteDoa() {
    List<String> favoriteDoaStrings = prefs.getStringList('favoriteDoaList') ?? [];
    setState(() {
      favoriteDoaList = favoriteDoaStrings.map((doaString) {
        List<String> parts = doaString.split('|');
        return DoaModel(judul: parts[0], indo: parts[1], arab: parts[2]);
      }).toList();
    });
  }

  void _loadFavoriteAsmaulHusna() {
    List<String> favoriteAsmaulHusnaStrings = prefs.getStringList('favoriteAsmaulHusnaList') ?? [];
    setState(() {
      favoriteAsmaulHusnaList = favoriteAsmaulHusnaStrings.map((asmaulHusnaString) {
        List<String> parts = asmaulHusnaString.split('|');
        return AsmaulHusnaModel(indo: parts[0], latin: parts[1], arab: parts[2], id: '');
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 190, bottom: 20, top: 0),
              child: Text(
                'Favorit',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF4E7E95),
          bottom: TabBar(
            indicatorColor: Colors.orange,
            tabs: [
              Tab(
                child: Text(
                  'Favorit Doa',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Favorit Asmaul Husna',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFavoriteDoaTab(),
            _buildFavoriteAsmaulHusnaTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteDoaTab() {
    return favoriteDoaList.isNotEmpty
        ? ListView.builder(
            itemCount: favoriteDoaList.length,
            itemBuilder: (context, index) {
              final DoaModel doa = favoriteDoaList[index];
              return Card(
                color: Color.fromARGB(255, 238, 236, 236),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Image.asset(
                    'assets/heart.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    doa.judul,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        doa.arab,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        doa.indo,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum ada data favorit doa sama sekali!',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'emoticon.png',
                  width: 60,
                  height: 60,
                ),
              ],
            ),
          );
  }

  Widget _buildFavoriteAsmaulHusnaTab() {
    return favoriteAsmaulHusnaList.isNotEmpty
        ? ListView.builder(
            itemCount: favoriteAsmaulHusnaList.length,
            itemBuilder: (context, index) {
              final AsmaulHusnaModel asmaulHusna = favoriteAsmaulHusnaList[index];
              return Card(
                color: Color.fromARGB(255, 238, 236, 236),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                leading: Image.asset(
                  'assets/heart.png',
                  width: 40,
                  height: 40,
                ),
                title: Text(
                  asmaulHusna.indo,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Posisikan ke kanan
                      children: [
                        Expanded(
                          child: Text(
                            '', 
                          ),
                        ),
                        Text(
                          asmaulHusna.arab,
                          textAlign: TextAlign.right, 
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      asmaulHusna.latin,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                ),
              );
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum ada data favorit asmaul husna sama sekali!',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'emoticon.png',
                  width: 60,
                  height: 60,
                ),
              ],
            ),
          );
  }
}
