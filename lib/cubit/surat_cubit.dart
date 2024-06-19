import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:quranjourney/data/models/surat_model.dart';
import 'package:equatable/equatable.dart';

part 'surat_state.dart';

class SuratCubit extends Cubit<SuratState> {
  SuratCubit(
    this.apiService,
  ) : super(SuratInitial());

  final ApiService apiService;

  void getAllSurat() async {
    emit(SuratLoading());
    final result = await apiService.getAllSurat();
    result.fold(
      (error) => emit(SuratError(message: error)),
      (data) => emit(SuratLoaded(listSurat: data)),
    );
  }
}
