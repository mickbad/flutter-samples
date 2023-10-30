import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_essais/views/defaultdesign_page.dart';
import 'package:riverpod_essais/views/home_page.dart';

import 'controlers/log.dart';
import 'controlers/route_generator.dart';

void main() async {
  // for logging to file (notamment)
  WidgetsFlutterBinding.ensureInitialized();

  // init log
  await logger.cleanFileLogs();
  logger.logLevel = LogLevel.trace;
  logger.i("Riverpod works!");
  logger.i("Log file : ${logger.pathname}");

  // start app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [MainObserver()],
      child: const AppInit(),
    );
  }
}

///
/// Observations des providers pour les variables states
///
class MainObserver implements ProviderObserver {
  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    logger.t('Added: $provider : $value(${value.runtimeType})');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    logger.t('Disposed: $provider');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    logger.t('Update: $provider : $newValue');
  }

  @override
  void providerDidFail(ProviderBase provider, Object error, StackTrace stackTrace, ProviderContainer container) {
    // TODO: implement providerDidFail
    logger.t('Failed update: $provider : $error');
  }
}

///
/// Initialisation de l'application globale
/// avec les chemins des pages
///
class AppInit extends StatelessWidget {
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  const AppInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      debugShowCheckedModeBanner: false,
      title: 'Riverpod works!',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Définition de la route à appeler à l'ouverture
      initialRoute: '/',

      // liste de l'ensemble des routes de mon application
      onGenerateRoute: RouteGenerator.generateRoute,

      home: const AppDefaultDesign(childName: "home", child: HomePage(),),
    );
  }
}
