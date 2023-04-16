import 'package:bimbeer/app_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/router/app_router.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(App(appRouter: AppRouter(),));
}
