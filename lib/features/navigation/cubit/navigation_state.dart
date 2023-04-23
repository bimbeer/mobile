part of 'navigation_cubit.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  final String currentRoute = AppRoute.pairs;

  @override
  List<Object> get props => [currentRoute];
}

class NavigationPairs extends NavigationState {}

class NavigationChat extends NavigationState {}

class NavigationProfile extends NavigationState {}