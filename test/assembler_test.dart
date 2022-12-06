import 'package:hrvm/core/assembler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('用例-1-指令解析', () {
    Assembler assembler = Assembler();
    var inst_LDA_abs_1 = assembler.assembleLine(1, "LDA 1");
    var inst_LDA_abs_a = assembler.assembleLine(1, "LDA a");
    var inst_LDA_ind_2 = assembler.assembleLine(1, "LDA (2)");
    var inst_LDA_ind_b = assembler.assembleLine(1, "LDA (b)");
    var inst_LDA_imme_3 = assembler.assembleLine(1, "LDA #3");
    var inst_LDA_imme_c = assembler.assembleLine(1, "LDA #c");
    print("指令解析完成");
  });

  test("用例-2-伪指令解析", () {
    Assembler assembler = Assembler();
    var inst_DB = assembler.assemble(".DB name 5");
    print("伪指令解析完成");
  });

  test("用例-3-标签解析", () {
    Assembler assembler = Assembler();
    var inst_label = assembler.assemble("labelName:");
    print("标签解析完成");
  });

  test("用例-4-编译", () {
    Assembler assembler = Assembler();
    String sourceCode = """
.db a 0
.db b 1
start:
    PLA
    STA a
    PLA
    STA b
    SUB a
    PHA
    LDA a
    SUB b
    PHA
    JMP start
""";
    assembler.assemble(sourceCode);
    print("汇编代码解析完成");
  });
}
