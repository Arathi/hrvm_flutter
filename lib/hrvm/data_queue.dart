import 'dart:collection';

import 'data.dart';

class DataQueue {
  late Queue<Data> datas;

  bool get isEmpty => datas.isEmpty;
  bool get isNotEmpty => datas.isNotEmpty;
  int get length => datas.length;

  Data? pop() {
    if (isNotEmpty) {
      return datas.removeFirst();
    }
    return null;
  }

  void push(Data data) {
    datas.addLast(data);
  }
}