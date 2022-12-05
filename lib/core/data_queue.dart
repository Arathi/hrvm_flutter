import 'dart:collection';

import 'data.dart';
import 'exceptions.dart';

class DataQueue {
  late Queue<Data> datas;

  bool get isEmpty => datas.isEmpty;
  bool get isNotEmpty => datas.isNotEmpty;
  int get length => datas.length;

  DataQueue() {
    datas = Queue<Data>();
  }

  DataQueue.of(List<dynamic> list) {
    datas = Queue<Data>();
    for (dynamic v in list) {
      if (v is int) {
        push(Data.int(v));
      }
      else if (v is String && v.length == 1) {
        push(Data.char(v));
      }
      else if (v is Data) {
        push(v);
      }
      else {
        throw RuntimeError("初始化队列时传入了无效类型的值：$v");
      }
    }
  }

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