import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranjourney/cubit/asmaulhusna_cubit.dart';
import 'package:quranjourney/cubit/asmaulhusna_state.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:quranjourney/data/models/asmaul_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsmaulHusnaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsmaulHusnaCubit(ApiService(client: http.Client()))..fetchAsmaulHusna(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Asmaul Husna', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF4E7E95),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<AsmaulHusnaCubit, AsmaulHusnaState>(
          builder: (context, state) {
            if (state is AsmaulHusnaLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AsmaulHusnaLoaded) {
              return ListView.builder(
                itemCount: state.asmaulHusna.length,
                itemBuilder: (context, index) {
                  final item = state.asmaulHusna[index];
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.indo}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Row( 
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded( 
                                    child: Text(
                                      '${item.arab}',
                                      textAlign: TextAlign.end, 
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4), 
                              Text(
                                '${item.latin}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          trailing: FutureBuilder<bool>(
                            future: _isFavorite(item),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _toggleFavorite(context, item);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _toggleFavorite(context, item);
                                  },
                                );
                              }
                            },
                          ),
                          leading: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.brightness_5, size: 52, color: const Color(0xFF4E7E95),),
                              Positioned(
                                top: 10,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is AsmaulHusnaError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Center(child: Text('Start by fetching data'));
            }
          },
        ),
      ),
    );
  }

  Future<bool> _isFavorite(AsmaulHusnaModel item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteAsmaulHusnaList = prefs.getStringList('favoriteAsmaulHusnaList') ?? [];
    String asmaulHusnaString = '${item.indo}|${item.latin}|${item.arab}';
    return favoriteAsmaulHusnaList.contains(asmaulHusnaString);
  }

  void _toggleFavorite(BuildContext context, AsmaulHusnaModel item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> favoriteAsmaulHusnaList = prefs.getStringList('favoriteAsmaulHusnaList') ?? [];
    String asmaulHusnaString = '${item.indo}|${item.latin}|${item.arab}';

    if (favoriteAsmaulHusnaList.contains(asmaulHusnaString)) {
      favoriteAsmaulHusnaList.remove(asmaulHusnaString);
    } else {
      favoriteAsmaulHusnaList.add(asmaulHusnaString);
    }

    await prefs.setStringList('favoriteAsmaulHusnaList', favoriteAsmaulHusnaList);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Asmaul Husna ${item.indo} ${favoriteAsmaulHusnaList.contains(asmaulHusnaString) ? 'ditambahkan ke' : 'dihapus dari'} favorit.')),
    );

    // Refresh UI
    BlocProvider.of<AsmaulHusnaCubit>(context).fetchAsmaulHusna();
  }
}
