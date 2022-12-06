import 'package:hrvm/core/instruction.dart';

class Program {
  late Map<int, Instruction> _instructions;
  late Map<String, int> _labels;
  late Map<String, int> _variables;

  Program.bytes(List<int> bytes) {
    _labels = <String, int>{};
    _variables = <String, int>{};
  }

  Program.link(
    Map<int, Instruction> instructions,
    Map<String, int> labels,
    this._variables,
  ) {}
}
