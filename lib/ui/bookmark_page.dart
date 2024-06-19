import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late SharedPreferences _preferences;
  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  void _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      bookmarks = _preferences.getStringList('bookmarks') ?? [];
    });
  }

  void _removeBookmark(String bookmark) {
    bookmarks.remove(bookmark);
    _preferences.setStringList('bookmarks', bookmarks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Bookmarks Ayat',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF4E7E95),
      ),
      body: bookmarks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum ada data bookmark ayat sama sekali!',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'emoticon.png',
                    height: 60,
                    width: 60,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final parts = bookmarks[index].split('|');
                if (parts.length < 3) {
                  return Container(); // Skip invalid bookmark data
                }
                final ayatNumber = parts[0];
                final suratName = parts[1];
                final dateTime = DateTime.parse(parts[2]);

                return Card(
                  color: Color.fromARGB(255, 238, 236, 236),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terakhir Dibaca',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4E7E95),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Surah: $suratName, Ayat: $ayatNumber',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${dateTime.day}-${dateTime.month}-${dateTime.year}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${dateTime.hour}:${dateTime.minute} WIB',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
