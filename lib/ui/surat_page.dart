import 'package:flutter/material.dart';
import 'package:quranjourney/common/contants.dart';
import 'package:quranjourney/cubit/surat_cubit.dart';
import 'package:quranjourney/data/models/surat_model.dart';
import 'package:quranjourney/ui/ayat_page.dart';
import 'package:quranjourney/ui/keterangansurat_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuratPage extends StatefulWidget {
  const SuratPage({Key? key}) : super(key: key);

  @override
  State<SuratPage> createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
  TextEditingController _searchController = TextEditingController();
  List<SuratModel> _filteredSuratList = [];
  String _filterOption = 'nama surat';

  @override
  void initState() {
    super.initState();
    context.read<SuratCubit>().getAllSurat();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final suratCubit = context.read<SuratCubit>();
    if (suratCubit.state is SuratLoaded) {
      final suratList = (suratCubit.state as SuratLoaded).listSurat;
      setState(() {
        if (_filterOption == 'nama surat') {
          _filteredSuratList = suratList
              .where((surat) =>
                  surat.namaLatin.toLowerCase().contains(_searchController.text.toLowerCase()))
              .toList();
        } else {
          _filteredSuratList = suratList
              .where((surat) => surat.arti.toLowerCase().contains(_searchController.text.toLowerCase()))
              .toList();
        }
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Surat', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4E7E95),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih Pencarian Berdasarkan:',
                  style: TextStyle(fontSize: 15.0),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: DropdownButton<String>(
                      value: _filterOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _filterOption = newValue!;
                          _searchController.clear();
                        });
                      },
                      items: <String>['nama surat', 'arti surat']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('search.png'),
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText:
                    _filterOption == 'nama surat' ? 'Cari nama surat...' : 'Cari arti surat...',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<SuratCubit, SuratState>(
              builder: (context, state) {
                if (state is SuratLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SuratLoaded) {
                  final suratList =
                      _searchController.text.isEmpty ? state.listSurat : _filteredSuratList;
                  if (suratList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _filterOption == 'nama surat'
                              ? 'Nama surat yang anda cari tidak ada dalam daftar surat, harap masukkan nama surat dengan benar!'
                              : 'Arti surat yang anda cari tidak ada dalam daftar surat, harap masukkan arti surat dengan benar!',
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final surat = suratList[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              '${surat.nomor}',
                              style: const TextStyle(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          title: Text('${surat.namaLatin}, ${surat.nama}'),
                          subtitle: Text('${surat.arti}, ${surat.jumlahAyat} Ayat.'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF4E7E95),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AyatPage(surat: surat);
                                  }));
                                },
                                child: const Text('Baca'),
                              ),
                              const SizedBox(width: 8.0),
                              IconButton(
                                icon: const Icon(Icons.info),
                                color: const Color(0xFF4E7E95),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return KeteranganSuratPage(surat: surat);
                                  }));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: suratList.length,
                  );
                }

                if (state is SuratError) {
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
      ),
    );
  }
}
