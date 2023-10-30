import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/counter_model.dart';

///
/// Counters providers
///

final counterProviderA = ChangeNotifierProvider<CounterModel>((ref) {
  return CounterModel();
});

final counterProviderB = ChangeNotifierProvider<CounterModel>((ref) {
  return CounterModel(counter: -9);
});

final counterStateProvider = StateProvider<int>((ref) {
  return CounterModel().counter;
});
