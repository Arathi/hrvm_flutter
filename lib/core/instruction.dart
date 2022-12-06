enum OpCode {
  pla,
  pha,
  lda,
  sta,
  add,
  sub,
  inc,
  dec,
  jmp,
  beq,
  bmi,
}

enum AddressMode {
  // 无效
  invalid,
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

class Instruction {
  int? offset;
  OpCode opCode;
  AddressMode addressMode;
  int? operand;
  String? operandName;

  Instruction(this.opCode, this.addressMode, {this.operand});

  Instruction.pla() : this(OpCode.pla, AddressMode.implied);

  Instruction.pha() : this(OpCode.pha, AddressMode.implied);

  Instruction.lda(AddressMode mode, int? operand)
      : this(OpCode.lda, mode, operand: operand);

  Instruction.sta(AddressMode mode, int? operand)
      : this(OpCode.sta, mode, operand: operand);

  Instruction.add(AddressMode mode, int? operand)
      : this(OpCode.add, mode, operand: operand);

  Instruction.sub(AddressMode mode, int? operand)
      : this(OpCode.sub, mode, operand: operand);

  Instruction.inc(AddressMode mode, int? operand)
      : this(OpCode.inc, mode, operand: operand);

  Instruction.dec(AddressMode mode, int? operand)
      : this(OpCode.dec, mode, operand: operand);

  Instruction.jmp(int? operand)
      : this(OpCode.jmp, AddressMode.absolute, operand: operand);

  Instruction.beq(int? operand)
      : this(OpCode.beq, AddressMode.absolute, operand: operand);

  Instruction.bmi(int? operand)
      : this(OpCode.bmi, AddressMode.absolute, operand: operand);

  @override
  String toString() {
    String opCodeName;
    switch (opCode) {
      case OpCode.pla:
        opCodeName = "PLA";
        break;
      case OpCode.pha:
        opCodeName = "PHA";
        break;
      case OpCode.lda:
        opCodeName = "LDA";
        break;
      case OpCode.sta:
        opCodeName = "STA";
        break;
      case OpCode.add:
        opCodeName = "ADD";
        break;
      case OpCode.sub:
        opCodeName = "SUB";
        break;
      case OpCode.inc:
        opCodeName = "INC";
        break;
      case OpCode.dec:
        opCodeName = "DEC";
        break;
      case OpCode.jmp:
        opCodeName = "JMP";
        break;
      case OpCode.beq:
        opCodeName = "BEQ";
        break;
      case OpCode.bmi:
        opCodeName = "BMI";
        break;
    }

    var operandValue = "";
    var operandText = "";
    switch (addressMode) {
      case AddressMode.absolute:
        operandValue = (operandName != null) ? operandName! : "${operand!}";
        operandText = operandValue;
        break;
      case AddressMode.indirect:
        operandValue = (operandName != null) ? operandName! : "${operand!}";
        operandText = "($operandValue)";
        break;
      case AddressMode.immediate:
        operandValue = (operandName != null) ? operandName! : "${operand!}";
        operandText = "#$operandValue";
        break;
      default:
        operandText = "";
    }

    return "$opCodeName $operandText";
  }
}
