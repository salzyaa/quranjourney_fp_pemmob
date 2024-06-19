import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranjourney/cubit/doa_cubit.dart';
import 'package:quranjourney/cubit/doa_state.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:quranjourney/data/models/doa_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DoaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoaCubit(ApiService(client: http.Client()))..fetchDoa(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Doa-Doa', style: TextStyle(color: Colors.white)), 
          backgroundColor: const Color(0xFF4E7E95),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<DoaCubit, DoaState>(
          builder: (context, state) {
            if (state is DoaLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoaLoaded) {
              return DoaListView(doaList: state.doa);
            } else if (state is DoaError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Center(child: Text('Start by fetching data'));
            }
          },
        ),
      ),
    );
  }
}

class DoaListView extends StatefulWidget {
  final List<DoaModel> doaList;

  const DoaListView({Key? key, required this.doaList}) : super(key: key);

  @override
  _DoaListViewState createState() => _DoaListViewState();
}

class _DoaListViewState extends State<DoaListView> {
  late List<DoaModel> filteredDoaList;
  TextEditingController _searchController = TextEditingController();
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    filteredDoaList = widget.doaList;
    _searchController.addListener(filterDoaList);
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(filterDoaList);
    _searchController.dispose();
    super.dispose();
  }

  void filterDoaList() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoaList = widget.doaList.where((doa) {
        return doa.judul.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleFavorite(DoaModel doa) async {
    if (prefs == null) return;
    
    List<String> favoriteDoaList = prefs!.getStringList('favoriteDoaList') ?? [];

    String doaString = '${doa.judul}|${doa.indo}|${doa.arab}';
    String message;
    if (favoriteDoaList.contains(doaString)) {
      favoriteDoaList.remove(doaString);
      message = '${doa.judul} dihapus dari favorit.';
    } else {
      favoriteDoaList.add(doaString);
      message = '${doa.judul} ditambahkan ke favorit.';
    }

    await prefs!.setStringList('favoriteDoaList', favoriteDoaList);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {});
  }

  bool _isFavorite(DoaModel doa) {
    if (prefs == null) return false;

    List<String> favoriteDoaList = prefs!.getStringList('favoriteDoaList') ?? [];
    String doaString = '${doa.judul}|${doa.indo}|${doa.arab}';
    return favoriteDoaList.contains(doaString);
  }

  @override
  Widget build(BuildContext context) {
    return prefs == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari Nama Doa...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'search.png',
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredDoaList.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredDoaList.length,
                        itemBuilder: (context, index) {
                          final DoaModel doa = filteredDoaList[index];
                          return _buildDoaCard(index, doa);
                        },
                      )
                    : Center(
                        child: Text(
                          'Nama doa yang anda cari tidak ada dalam daftar doa-doa, harap masukkan nama doa dengan benar!',
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          );
  }

  Widget _buildDoaCard(int index, DoaModel doa) {
    return Card(
      color: const Color(0xFF4E7E95),
      child: ListTile(
        leading: Text(
          (index + 1).toString(),
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        title: Text(
          doa.judul,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              doa.arab,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              doa.indo,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            _isFavorite(doa) ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () => _toggleFavorite(doa),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DoaPage(),
    );
  }
}
