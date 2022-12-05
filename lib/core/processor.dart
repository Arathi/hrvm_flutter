import 'exceptions.dart';
import 'machine.dart';

import 'data.dart';

enum AddressMode {
  // 累加器寻址
  accumulator,
  // 绝对寻址
  absolute,
  // 立即寻址
  immediate,
  // 隐含寻址
  implied,
  // 间接寻址
  indirect,
  // 相对寻址
  relative,
}

class Processor {
  late Machine machine;
  
  Data? acc;
  int pc = 0;
  int counter = 0;
  
  Processor(this.machine);

  void reset() {
    acc = null;
    pc = 0;
    counter = 0;
  }

  void pla() {
    acc = machine.inbox.pop();
  }

  void pha() {
    machine.outbox.push(acc!);
    acc = null;
  }

  int indirectAddressing(int address) {
    Data? data = machine.memory.read(address);

    if (data == null) {
      throw RuntimeError("memory[$address] = null");
    }
    
    if (data.type != DataType.integer) {
      throw RuntimeError("memory[$address] = $data");
    }

    return data.value;
  }

  void lda(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    
    // 立即寻址
    if (addressMode == AddressMode.immediate) {
      if (operand >= 0x10000) {
        acc = Data.char(String.fromCharCode(operand - 0x10000));
      }
      else {
        acc = Data.int(operand);
      }
      return;
    }

    // 间接寻址
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
    }

    acc = machine.memory.read(address);
  }

  void sta(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
    }
    machine.memory.write(address, acc);
  }

  void add(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    // 立即寻址
    if (addressMode == AddressMode.immediate) {
      if (operand >= -999 && operand <= 999) {
        acc!.value += operand;
      }
      return;
    }

    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
    }

    var data = machine.memory.read(address);
    acc = acc! + data!;
  }

  void sub(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    // 立即寻址
    if (addressMode == AddressMode.immediate) {
      if (operand >= -999 && operand <= 999) {
        acc!.value -= operand;
      }
      return;
    }

    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
    }

    var data = machine.memory.read(address);
    acc = acc! - data!;
  }

  void inc(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
    }

    var data = machine.memory.read(address);
    acc = data!.inc();
  }

  void dec(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
    }

    var data = machine.memory.read(address);
    acc = data!.dec();
  }

  void jmp(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
    }

    pc = operand;
  }

  void beq(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    if (addressMode == AddressMode.relative) {
      if (acc!.value == 0) {
        pc = operand;
      }
      return;
    }

    if (acc!.value == 0) {
      pc = operand;
    }
  }

  void bmi(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    if (addressMode == AddressMode.relative) {
      if (acc!.value < 0) {
        pc += operand;
      }
      return;
    }

    if (acc!.value < 0) {
      pc = operand;
    }
  }
}