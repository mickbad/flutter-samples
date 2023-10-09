import 'package:flutter/material.dart';
import 'package:riverpod_essais/views/home_page.dart';
import 'package:riverpod_essais/views/search_page.dart';
import 'package:riverpod_essais/views/random_page.dart';

import '../views/defaultdesign_page.dart';

///
/// Générateur de routes dans l'application
///
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const AppDefaultDesign(childName: "home", child: HomePage(),));

      case '/search':
        return MaterialPageRoute(builder: (context) => const AppDefaultDesign(childName: "search", child: SearchPage(),));

      case '/random':
        return MaterialPageRoute(builder: (context) => const RandomPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return AppDefaultDesign(childName: "error", child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text('Page not found!'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text("Back to home"),
              )
            ],
          ),
        ), // Center
      ); // Scaffold
    }); // MaterialPageRoute
  }
}
