import 'data.dart';
import 'exceptions.dart';

class DataQueue {
  late List<Data> datas;

  bool get isEmpty => datas.isEmpty;
  bool get isNotEmpty => datas.isNotEmpty;
  int get length => datas.length;
  int currentIndex = 0;

  DataQueue() {
    datas = <Data>[];
  }

  DataQueue.of(List<dynamic> list) {
    datas = <Data>[];
    for (dynamic v in list) {
      if (v is int) {
        push(Data.int(v));
      } else if (v is String && v.length == 1) {
        push(Data.char(v));
      } else if (v is Data) {
        push(v);
      } else {
        throw RuntimeError("初始化队列时传入了无效类型的值：$v");
      }
    }
  }

  Data? operator [](int index) {
    return datas[index];
  }

  Data? pop() {
    if (isNotEmpty) {
      return datas.removeAt(0);
    }
    return null;
  }

  void push(Data data) {
    datas.add(data);
  }
}
