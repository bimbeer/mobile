import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/router/app_router.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationPairs());

  void navigateToChat() {
    emit(NavigationChat());
  }

  void navigateToPairs() {
    emit(NavigationPairs());
  }

  void navigateToProfile() {
    emit(NavigationProfile());
  }
}
