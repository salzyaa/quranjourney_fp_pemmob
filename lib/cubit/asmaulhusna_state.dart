import 'package:quranjourney/data/models/asmaul_model.dart';

abstract class AsmaulHusnaState {}

class AsmaulHusnaInitial extends AsmaulHusnaState {}

class AsmaulHusnaLoading extends AsmaulHusnaState {}

class AsmaulHusnaLoaded extends AsmaulHusnaState {
  final List<AsmaulHusnaModel> asmaulHusna;

  AsmaulHusnaLoaded(this.asmaulHusna);
}

class AsmaulHusnaError extends AsmaulHusnaState {
  final String error;

  AsmaulHusnaError(this.error);
}
