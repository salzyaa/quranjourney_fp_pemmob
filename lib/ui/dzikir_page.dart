import 'dart:html' as html; // Import dart:html for web-specific audio manipulation
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(
    home: DzikirPage(),
  ));
}

class DzikirPage extends StatefulWidget {
  @override
  _DzikirPageState createState() => _DzikirPageState();
}

class _DzikirPageState extends State<DzikirPage> {
  final List<Map<String, String>> dzikirList = [
    {
      'judul': 'Istighfar',
      'arab': 'أَسْتَغْفِرُ اللهَ',
      'latin': 'Astaghfirullah',
      'terjemahan': '"Aku memohon ampun kepada Allah."',
    },
    {
      'judul': 'Tasbih',
      'arab': 'سُبْحَانَ اللهِ',
      'latin': 'Subhanallah',
      'terjemahan': '"Mahasuci Allah."',
    },
    {
      'judul': 'Tahmid',
      'arab': 'اَلْحَمْدُ لِلَّهِ',
      'latin': 'Alhamdulillah',
      'terjemahan': '"Segala puji bagi Allah."',
    },
    {
      'judul': 'Takbir',
      'arab': 'اللهُ أَكْبَرُ',
      'latin': 'Allahu akbar',
      'terjemahan': '"Allah Mahabesar."',
    },
    {
      'judul': 'Tahlil',
      'arab': 'لا إِلَهَ إِلَّا اللهُ',
      'latin': 'Laa ilaaha illa Allah',
      'terjemahan': '"Tidak ada tuhan selain Allah SWT."',
    },
  ];

  int _counter = 0;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  CarouselController carouselController = CarouselController();

  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  void _incrementCounter() async {
    setState(() {
      if (_counter < 33) {
        _counter++;
        if (_counter == 33) {
          _showAlertDialog();
        }
        _playAudio(); // Memanggil fungsi untuk memainkan audio
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _showAlertDialog() {
    _playNotificationAudio(); // Memanggil fungsi untuk memainkan audio notifikasi
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifikasi!'),
          content: Text('Anda sudah membaca kalimat ini sebanyak 33x.'),
          actions: <Widget>[
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _playAudio() async {
    // Handling audio play for web using dart:html
    html.AudioElement audioElement = html.AudioElement();
    audioElement.src = 'assets/click.mp3'; // Replace with your audio file path
    audioElement.load();
    audioElement.play();
  }

  void _playNotificationAudio() async {
    // Handling notification audio play for web using dart:html
    html.AudioElement audioElement = html.AudioElement();
    audioElement.src = 'assets/notifikasi.mp3'; // Path to notification audio file
    audioElement.load();
    audioElement.play();
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Release resources when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dzikir',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4E7E95),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              carouselController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            color: _showLeftArrow ? Colors.white : Colors.transparent,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              carouselController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            color: _showRightArrow ? Colors.white : Colors.transparent,
          ),
        ],
      ),
      body: CarouselSlider(
        carouselController: carouselController,
        items: dzikirList.map((dzikir) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Card(
                  color: const Color(0xFF4E7E95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          dzikir['judul']!,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          dzikir['arab']!,
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          dzikir['latin']!,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          dzikir['terjemahan']!,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 187, 0).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 4.0,
                          ),
                          child: Text(
                            'Dibaca 33x',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: _resetCounter,
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.replay,
                                    color: const Color(0xFF4E7E95),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Tasbih Digital',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  '33',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4E7E95),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: _incrementCounter,
                          child: Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                '$_counter',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4E7E95),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          autoPlay: false,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            setState(() {
              _showLeftArrow = index != 0;
              _showRightArrow = index != dzikirList.length - 1;
            });
            _resetCounter(); // Reset counter when page changes
          },
        ),
      ),
    );
  }
}
