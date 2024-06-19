import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:quranjourney/data/models/doa_model.dart';
import 'package:quranjourney/cubit/doa_state.dart';

class DoaCubit extends Cubit<DoaState> {
  final ApiService apiService;

  DoaCubit(this.apiService) : super(DoaInitial());

  Future<void> fetchDoa() async {
    try {
      emit(DoaLoading());
      final doaLists = await Future.wait([apiService.fetchDoaFromApi1(), apiService.fetchDoaFromApi2()]);
      List<DoaModel> combinedDoaList = [];
      doaLists.forEach((apiDoaList) {
        combinedDoaList.addAll(apiDoaList);
      });
      emit(DoaLoaded(combinedDoaList));
    } catch (e) {
      emit(DoaError(e.toString()));
    }
  }
}
