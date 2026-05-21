import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void switchLocale(String languageCode) {
    emit(Locale(languageCode));
  }
}
