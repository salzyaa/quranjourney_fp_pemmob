import 'package:quranjourney/data/models/doa_model.dart';

abstract class DoaState {}

class DoaInitial extends DoaState {}

class DoaLoading extends DoaState {}

class DoaLoaded extends DoaState {
  final List<DoaModel> doa;

  DoaLoaded(this.doa);
}

class DoaError extends DoaState {
  final String error;

  DoaError(this.error);
}