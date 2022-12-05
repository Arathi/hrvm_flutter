import 'data.dart';

class Memory {
  int width;
  int height;
  int get size => width * height;

  late List<Data?> datas;

  Memory({this.width = 1, this.height = 1}) {
    datas = <Data?>[];
    initDatas();
  }

  void initDatas() {
    datas = <Data?>[];
    for (int index = 0; index < size; index++) {
      datas.add(null);
    }
  }

  Data? read(int address) {
    return datas[address];
  }

  void write(int address, Data? value) {
    datas[address] = value;
  }
}