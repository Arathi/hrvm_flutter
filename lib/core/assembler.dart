import 'instruction.dart';
import 'program.dart';
import 'exceptions.dart';

class Assembler {
  Map<int, Instruction?> _instructions = <int, Instruction?>{};
  Map<String, int> _variables = <String, int>{};
  Map<String, int> _labels = <String, int>{};

  static RegExp identifierRegex = RegExp(r"^[A-Za-z_]([0-9A-Za-z_])*?$");
  static RegExp numberRegex = RegExp(r"^[0-9]+$");

  void assemble(String sourceCode) {
    List<String> lines = sourceCode.split("\n");
    int lineNo = 0;
    for (var line in lines) {
      assembleLine(++lineNo, line);
    }
  }

  AddressMode parseAddressMode(String operandStr) {
    if (operandStr.startsWith("#")) {
      return AddressMode.immediate;
    }
    if (operandStr.startsWith("(") && operandStr.endsWith(")")) {
      return AddressMode.indirect;
    }
    if (identifierRegex.firstMatch(operandStr) != null ||
        numberRegex.firstMatch(operandStr) != null) {
      return AddressMode.absolute;
    }
    return AddressMode.invalid;
  }

  Instruction? assembleLine(int lineNo, String line) {
    Instruction? inst;
    line = line.trim();

    if (line.endsWith(":")) {
      var label = line.substring(0, line.length - 1);
      _labels[label] = lineNo;
      return null;
    }

    List<String> tokens = line.split(" ");
    if (tokens.length == 1) {
      String opCode = tokens[0].toUpperCase();
      switch (opCode) {
        case "PLA":
          inst = Instruction.pla();
          break;
        case "PHA":
          inst = Instruction.pha();
          break;
      }
    } else if (tokens.length == 2) {
      String opCode = tokens[0].toUpperCase();
      String operandStr = tokens[1];
      AddressMode addressMode = parseAddressMode(operandStr);
      int? operand = null;
      String? operandName = null;
      if (addressMode == AddressMode.absolute) {
        operand = int.tryParse(operandStr);
        if (operand == null) {
          operandName = operandStr;
        }
      } else if (addressMode == AddressMode.indirect) {
        operandStr = operandStr.substring(1, operandStr.length - 1);
        operand = int.tryParse(operandStr);
        if (operand == null) {
          operandName = operandStr;
        }
      } else if (addressMode == AddressMode.immediate) {
        operandStr = operandStr.substring(1);
        operand = int.tryParse(operandStr);
        if (operand == null) {
          operandName = operandStr;
        }
      } else {
        throw CompileError("无效的寻址方式：$addressMode");
      }

      switch (opCode) {
        case "LDA":
          inst = Instruction.lda(addressMode, operand);
          break;
        case "STA":
          if (addressMode == AddressMode.immediate) {
            throw CompileError("STA指令不支持立即寻址");
          }
          inst = Instruction.sta(addressMode, operand);
          break;
        case "ADD":
          inst = Instruction.add(addressMode, operand);
          break;
        case "SUB":
          inst = Instruction.sub(addressMode, operand);
          break;
        case "INC":
          if (addressMode == AddressMode.immediate) {
            throw CompileError("INC指令不支持立即寻址");
          }
          inst = Instruction.inc(addressMode, operand);
          break;
        case "DEC":
          if (addressMode == AddressMode.immediate) {
            throw CompileError("DEC指令不支持立即寻址");
          }
          inst = Instruction.dec(addressMode, operand);
          break;
        case "JMP":
          if (addressMode != AddressMode.absolute) {
            throw CompileError("JMP指令只支持绝对寻址");
          }
          inst = Instruction.jmp(operand);
          break;
        case "BEQ":
          if (addressMode != AddressMode.absolute) {
            throw CompileError("BEQ指令只支持绝对寻址");
          }
          inst = Instruction.beq(operand);
          break;
        case "BMI":
          if (addressMode != AddressMode.absolute) {
            throw CompileError("BMI指令只支持绝对寻址");
          }
          inst = Instruction.bmi(operand);
          break;
      }

      if (inst != null && operandName != null) {
        inst.operandName = operandName;
      }
    } else if (tokens.length == 3) {
      String opCode = tokens[0].toUpperCase();
      if (opCode == ".DB") {
        String variableName = tokens[1];
        int? variableValue = int.tryParse(tokens[2]);
        if (identifierRegex.firstMatch(variableName) == null) {
          throw CompileError("无效的标识符：$variableName");
        }
        if (variableValue == null) {
          throw CompileError("无效的常量：${tokens[2]}");
        }
        _variables[variableName] = variableValue;
      } else {
        throw CompileError("编译失败：$line");
      }
    }

    if (inst != null) {
      _instructions[lineNo] = inst;
    }
    return inst;
  }

  // Program link() {}
}
