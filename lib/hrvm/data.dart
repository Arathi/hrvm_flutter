import 'exceptions.dart';

enum DataType {
  integer,
  character
}

class Data implements Comparable {
  late DataType type;
  late int value;

  Data.int(this.value) {
    type = DataType.integer;
  }

  Data.char(String char) {
    if (char.length == 1) {
      type = DataType.character;
      value = char.codeUnitAt(0);
    }
  }

  Data operator+(Data other) {
    if (type == DataType.integer && other.type == DataType.integer) {
      return Data.int(value + other.value);
    }
    throw RuntimeError("类型不都为整型，无法进行加法运算");
  }

  Data operator-(Data other) {
    if (type == other.type) {
      return Data.int(value - other.value);
    }
    throw RuntimeError("类型不一致，无法进行减法运算");
  }

  Data inc() {
    if (type == DataType.integer) {
      value++;
      return this;
    }
    throw RuntimeError("类型不为整型，无法自增");
  }

  Data dec() {
    if (type == DataType.integer) {
      value--;
      return this;
    }
    throw RuntimeError("类型不为整型，无法自减");
  }
  
  @override
  int compareTo(dynamic other) {
    if (type == DataType.integer && other is int) {
      return value - other;
    }
    else if (type == DataType.character && other is String && other.length == 1) {
      var code = other.codeUnitAt(0);
      return value - code;
    }
    else if (other is Data && type == other.type) {
      return value - other.value;
    }
    throw RuntimeError("类型不匹配，无法比较");
  }
}