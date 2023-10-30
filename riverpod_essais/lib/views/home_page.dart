import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controlers/log.dart';
import '../controlers/providers.dart';
import '../models/counter_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState;
    // "ref" can be used in all life-cycles of a StatefulWidget.
    final a = ref.read(counterProviderA);
    logger.i("home_page : counterA = ${a.counter}");
  }

  @override
  Widget build(BuildContext context) {
    final CounterModel counterA = ref.watch(counterProviderA);
    final CounterModel counterB = ref.watch(counterProviderB);
    final counter = ref.watch(counterStateProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            // 2. use the value
            child: Text('Value: $counter'),
            // 3. change the state inside a button callback
            onPressed: () => ref.read(counterStateProvider.notifier).state++,
          ),
          SizedBox.fromSize(size: const Size(10, 50)),

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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  counterA.decrementCounter();
                },
                child: const Text('-1'),
              ),

              ElevatedButton(
                onPressed: () {
                  counterA.resetCounter();
                },
                child: const Text('Reset A'),
              ),

              ElevatedButton(
                onPressed: () {
                  counterA.incrementCounter();
                },
                child: const Text('+1'),
              ),
            ]
          ),
          SizedBox.fromSize(size: const Size(10, 10)),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/random");
            },
            child: const Text('Random Page'),
          ),
          SizedBox.fromSize(size: const Size(10, 10)),

          ElevatedButton(
            onPressed: () {
              logger.logFile = !logger.logFile;
            },
            child: Text((!logger.logFile ? "Start file logging" : "Stop file logging")),
          ),
        ],
      ),
    );
  }
}
