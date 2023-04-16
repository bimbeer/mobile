import 'package:flutter/material.dart';

import '../../features/onboard/view/onboard_page.dart';

class AppRouter {
  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const OnboardPage());
      case '/create-account':
        return MaterialPageRoute(builder: (_) => const Placeholder());
      case '/sign-in':
        return MaterialPageRoute(builder: (_) => const Placeholder());
      default:
        return null;
    }
  }
}
