import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quranjourney/bloc/ayat_bloc.dart';
import 'package:quranjourney/data/models/surat_model.dart';

class AyatPage extends StatefulWidget {
  const AyatPage({
    Key? key,
    required this.surat,
  }) : super(key: key);
  final SuratModel surat;

  @override
  State<AyatPage> createState() => _AyatPageState();
}

class _AyatPageState extends State<AyatPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Future<SharedPreferences> _preferencesFuture = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    context.read<AyatBloc>().add(AyatGetEvent(noSurat: widget.surat.nomor));
    _audioPlayer = AudioPlayer();
  }

  void toggleBookmark(int ayatNumber, String suratName, SharedPreferences preferences) {
    List<String> bookmarks = preferences.getStringList('bookmarks') ?? [];
    String bookmark = '$ayatNumber|$suratName|${DateTime.now().toIso8601String()}';

    if (bookmarks.any((item) => item.split('|')[0] == '$ayatNumber' && item.split('|')[1] == suratName)) {
      // Jika ayat sudah terbookmark, hapus dari bookmark
      bookmarks.removeWhere((item) => item.split('|')[0] == '$ayatNumber' && item.split('|')[1] == suratName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Last read berhasil dihapus dari bookmark')),
      );
    } else {
      // Jika ayat belum terbookmark
      // Cek apakah ada bookmark pada surat yang sama
      List<String> sameSurahBookmarks = bookmarks.where((item) => item.split('|')[1] == suratName).toList();
      if (sameSurahBookmarks.isNotEmpty) {
        // Jika ada, tampilkan dialog konfirmasi
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Temukan ayat terakhir yang di-bookmark di surat yang sama
            String lastBookmark = sameSurahBookmarks.last;
            int lastBookmarkAyat = int.parse(lastBookmark.split('|')[0]);
            return AlertDialog(
              title: const Text('Konfirmasi'),
              content: Text(
                  'Terakhir Baca akan diubah dari Surah $suratName Ayat $lastBookmarkAyat ke Surah $suratName Ayat $ayatNumber. Yakin?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Jika pengguna memilih Batal, tutup dialog tanpa melakukan perubahan
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    // Jika pengguna memilih OK, update bookmark ayat yang baru
                    bookmarks.remove(lastBookmark);
                    bookmarks.add(bookmark);
                    preferences.setStringList('bookmarks', bookmarks);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Last read berhasil disimpan ke bookmark')),
                    );
                    setState(() {});
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Jika tidak ada bookmark pada surat yang sama, tambahkan bookmark baru
        bookmarks.add(bookmark);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Last read berhasil disimpan ke bookmark')),
        );
      }
    }

    // Update shared preferences
    preferences.setStringList('bookmarks', bookmarks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Surat',
        ),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: _preferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final preferences = snapshot.data!;
          return Column(
            children: [
              Card(
                color: const Color(0xFF4E7E95),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.surat.namaLatin,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (isPlaying) {
                                _audioPlayer.stop();
                                setState(() {
                                  isPlaying = false;
                                });
                              } else {
                                final url =
                                    'https://equran.nos.wjv-1.neo.id/audio-full/Misyari-Rasyid-Al-Afasi/${widget.surat.nomor.toString().padLeft(3, '0')}.mp3';
                                _audioPlayer.setUrl(url);
                                _audioPlayer.play();
                                setState(() {
                                  isPlaying = true;
                                });
                              }
                            },
                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                            label: Text(isPlaying ? 'Stop Audio Surah' : 'Play Audio Surah'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.surat.arti}, ${widget.surat.jumlahAyat} Ayat',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Image.asset(
                            'baca.png',
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: BlocBuilder<AyatBloc, AyatState>(
                  builder: (context, state) {
                    if (state is AyatLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is AyatLoaded) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final ayat = state.detail.ayat![index];
                          final bookmarks = preferences.getStringList('bookmarks') ?? [];
                          final isBookmarked = bookmarks.any((item) => item.split('|')[0] == '${ayat.nomor}' && item.split('|')[1] == widget.surat.namaLatin);

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF4E7E95),
                                child: Text(
                                  '${ayat.nomor}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${ayat.ar}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('${ayat.idn}'),
                              trailing: IconButton(
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                ),
                                onPressed: () {
                                  toggleBookmark(ayat.nomor!, widget.surat.namaLatin, preferences);
                                },
                              ),
                            ),
                          );
                        },
                        itemCount: state.detail.ayat!.length,
                      );
                    }
                    if (state is AyatError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }

                    return const Center(
                      child: Text('no data'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
