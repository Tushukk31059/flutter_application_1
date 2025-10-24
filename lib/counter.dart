
import 'package:mobx/mobx.dart';

part 'counter.g.dart'; // codegen ke liye

class Counter = _Counter with _$Counter;

abstract class _Counter with Store {
  @observable
  int value = 0; // observable state

  @action
  void increment() {
    
      value++;
    
    }
  }
