import 'package:bimbeer/features/authentication/view/login_page.dart';
import 'package:bimbeer/features/authentication/view/sign_up_page.dart';
import 'package:bimbeer/features/location/view/location_page.dart';
import 'package:bimbeer/features/pairs/view/pairs_page.dart';
import 'package:bimbeer/features/profile/view/profile_page.dart';
import 'package:flutter/material.dart';

import '../../features/beer/view/beer_page.dart';
import '../../features/onboard/view/onboard_page.dart';
import '../../features/personalInfo/view/personal_info_page.dart';

class AppRouter {
  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.onboard:
        return MaterialPageRoute(builder: (_) => const OnboardPage());
      case AppRoute.createAccount:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case AppRoute.signIn:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoute.pairs:
        return MaterialPageRoute(builder: (_) => const PairsPage());
      case AppRoute.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case AppRoute.editProfile:
        return MaterialPageRoute(builder: (_) => const PersonalInfoPage());
      case AppRoute.pickBeer:
        return MaterialPageRoute(builder: (_) => const BeerPage());
      case AppRoute.location:
        return MaterialPageRoute(builder: (_) => const LocationPage());
      default:
        return null;
    }
  }
}

abstract class AppRoute {
  static const String onboard = '/';
  static const String createAccount = '/create-account';
  static const String signIn = '/sign-in';
  static const String pairs = '/pairs';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String pickBeer = '/pick-beer';
  static const String location = '/location';
}
