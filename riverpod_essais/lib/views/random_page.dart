import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controlers/providers.dart';
import '../models/counter_model.dart';

///
/// Page d'exemple de traitement random
///
class RandomPage extends ConsumerWidget {
  const RandomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    final CounterModel counterA = ref.watch(counterProviderA);
    final CounterModel counterB = ref.watch(counterProviderB);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Other random page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter A : ${counterA.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox.fromSize(size: const Size(10, 50)),
            Text(
              'Counter B : ${counterB.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox.fromSize(size: const Size(10, 50)),
            Text(
              'Counter : $counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),

      )
    );
  }
}