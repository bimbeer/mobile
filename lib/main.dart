import 'package:bimbeer/app_bloc_observer.dart';
import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/location/data/repositories/location_repository.dart';
import 'package:bimbeer/features/pairs/data/repositories/interactions_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/view/app.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = const AppBlocObserver();

  final authenticationRepository = AuthenticaionRepository();
  final profileRepository = ProfileRepository();
  final storageRepository = StorageRepository();
  final locationRepository = LocationRepository();
  final interactionsRepository = InteractionsRepository();

  final user = await authenticationRepository.user.first;
  profileRepository.get(user.id);

  runApp(App(
    authenticationRepository: authenticationRepository,
    profileRepository: profileRepository,
    storageRepository: storageRepository,
    locationRepository: locationRepository,
    interactionsRepository: interactionsRepository,
  ));
}
