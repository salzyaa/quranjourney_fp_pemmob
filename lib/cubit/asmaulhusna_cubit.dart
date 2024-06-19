import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:quranjourney/cubit/asmaulhusna_state.dart';

class AsmaulHusnaCubit extends Cubit<AsmaulHusnaState> {
  final ApiService apiService;

  AsmaulHusnaCubit(this.apiService) : super(AsmaulHusnaInitial());

  Future<void> fetchAsmaulHusna() async {
    try {
      emit(AsmaulHusnaLoading());
      final asmaulHusna = await apiService.fetchAsmaulHusna();
      emit(AsmaulHusnaLoaded(asmaulHusna));
    } catch (e) {
      emit(AsmaulHusnaError(e.toString()));
    }
  }
}

