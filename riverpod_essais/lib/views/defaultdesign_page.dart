import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controlers/log.dart';
import '../controlers/providers.dart';

///
/// Page générative d'environnement design
///
class AppDefaultDesign extends ConsumerWidget {
  final Widget child;
  final String childName;

  const AppDefaultDesign({Key? key, required this.child, required this.childName}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    final counterA = ref.watch(counterProviderA);
    final colorInactive = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Riverpod works!"),
      ),

      bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home page
            IconButton(
              icon: Icon(Icons.home, color: (childName == 'home') ? Colors.orangeAccent : colorInactive),
              onPressed: () {
                logger.d("Go to home");
                Navigator.pushReplacementNamed(context, '/');
              },
            ),

            IconButton(
              icon: Icon(Icons.search, color: (childName == 'search') ? Colors.orangeAccent : colorInactive),
              onPressed: () {
                logger.d("Go to search");
                Navigator.pushReplacementNamed(context, '/search');
              },
            ),

            IconButton(
              icon: Icon(Icons.settings, color: (childName == 'settings') ? Colors.orangeAccent : colorInactive),
              onPressed: () {
                logger.d("Go to settings");
                Navigator.pushReplacementNamed(context, '/settings');
              },
            ),

            const IconButton(icon: Icon(Icons.person), onPressed: null),

            Text(counter.toString(), style: TextStyle(color: Theme.of(context).colorScheme.primary),),
            Text(counterA.counter.toString(), style: const TextStyle(color: Colors.red),),
          ]
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
