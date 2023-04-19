import 'package:bimbeer/features/authentication/view/login_page.dart';
import 'package:bimbeer/features/authentication/view/sign_up_page.dart';
import 'package:bimbeer/features/pairs/view/pairs_page.dart';
import 'package:flutter/material.dart';

import '../../features/onboard/view/onboard_page.dart';

class AppRouter {
  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const OnboardPage());
      case '/create-account':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/sign-in':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/pairs':
        return MaterialPageRoute(builder: (_) => const PairsPage());
      default:
        return null;
    }
  }
}
