import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controlers/providers.dart';
import '../models/counter_model.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CounterModel counterA = ref.watch(counterProviderA);
    final counter = ref.watch(counterStateProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reset Counters',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text("Counter A : ${counterA.counter}", style: Theme.of(context).textTheme.headlineSmall),
          Text("Counter : $counter", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox.fromSize(size: const Size(10, 50)),

          ElevatedButton(
            onPressed: () {
              counterA.resetCounter();
              ref.read(counterStateProvider.notifier).state = 0;
            },
            child: const Text('Reset'),
          ),

        ],
      ),
    );
  }
}
