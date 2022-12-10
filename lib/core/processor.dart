import 'package:logging/logging.dart';

import 'exceptions.dart';
import 'machine.dart';

import 'data.dart';
import 'instruction.dart';

class Processor {
  final Logger logger = Logger(
    "Processor"
  );
  late Machine machine;

  Data? acc;
  int pc = 0;
  int counter = 0;

  Processor(this.machine);

  void reset() {
    logger.level = Level.ALL;
    acc = null;
    pc = 0;
    counter = 0;
  }

  void pla() {
    acc = machine.inbox.pop();
    logger.info("PLA ; acc = $acc");
  }

  void pha() {
    if (acc == null) {
      throw RuntimeError("累加器为空，无法push到OUTBOX");
    }

    machine.outbox.push(acc!);
    logger.info("PHA ; acc = $acc");
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
      } else {
        acc = Data.int(operand);
      }
      logger.info("LDA #$operand");
      return;
    }

    // 间接寻址
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
      logger.info("LDA ($operand)");
    } else {
      logger.info("LDA $operand");
    }

    acc = machine.memory.read(address);
  }

  void sta(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
      logger.info("STA ($operand)");
    } else {
      logger.info("STA $operand");
    }

    machine.memory.write(address, acc);
  }

  void add(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    // 立即寻址
    if (addressMode == AddressMode.immediate) {
      if (operand >= -999 && operand <= 999) {
        acc!.value += operand;
        logger.info("ADD #$operand");
      }
      return;
    }

    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
      logger.info("ADD ($operand)");
    } else {
      logger.info("ADD $operand");
    }

    var data = machine.memory.read(address);
    acc = acc! + data!;
  }

  void sub(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    // 立即寻址
    if (addressMode == AddressMode.immediate) {
      if (operand >= -999 && operand <= 999) {
        acc!.value -= operand;
        logger.info("SUB #$operand");
      }
      return;
    }

    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
      logger.info("SUB ($operand)");
    } else {
      logger.info("SUB $operand");
    }

    var data = machine.memory.read(address);
    acc = acc! - data!;
  }

  void inc(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
      logger.info("INC ($operand)");
    } else {
      logger.info("INC $operand");
    }

    var data = machine.memory.read(address);
    acc = data!.inc();
  }

  void dec(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
      logger.info("DEC ($operand)");
    } else {
      logger.info("DEC $operand");
    }

    var data = machine.memory.read(address);
    acc = data!.dec();
  }

  void jmp(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    int address = operand;
    if (addressMode == AddressMode.indirect) {
      address = indirectAddressing(address);
      logger.info("JMP ($operand)");
    } else {
      logger.info("JMP $operand");
    }

    pc = operand;
  }

  void beq(int operand, {AddressMode addressMode = AddressMode.absolute}) {
    if (addressMode == AddressMode.relative) {
      if (acc!.value == 0) {
        pc += operand;
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
