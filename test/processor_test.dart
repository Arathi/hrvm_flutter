import 'package:hrvm/core/data.dart';
import 'package:hrvm/core/instruction.dart';
import 'package:hrvm/core/processor.dart';
import 'package:hrvm/core/machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("case-01", () {
    Machine machine = Machine(memoryWidth: 4, memoryHeight: 4, input: [1, 2, 'A', 'B', 3, 4, 'C', 'D']);
    Processor processor = machine.processor;
    // PLA - int
    processor.pla(); // 1
    expect(processor.acc!.type, DataType.integer);
    expect(processor.acc!.value, 1);
    print("acc = ${processor.acc!}");
    processor.pla(); // 2

    // PHA
    processor.pha(); // 2
    expect(processor.acc, null);

    // PLA - char
    processor.pla(); // 'A'
    int codeA = 'A'.codeUnitAt(0);
    int codeC = 'C'.codeUnitAt(0);
    expect(processor.acc!.type, DataType.character);
    expect(processor.acc!.value, codeA);
    print("acc = ${processor.acc!} （${processor.acc!.value}）");

    // LDA #int
    processor.lda(4, addressMode: AddressMode.immediate);
    expect(processor.acc!.type, DataType.integer);
    expect(processor.acc!.value, 4);

    processor.lda(0x10000+codeA, addressMode: AddressMode.immediate);
    expect(processor.acc!.type, DataType.character);
    expect(processor.acc!.value, codeA);

    // STA addr
    processor.pla(); // 'B'
    processor.pla(); // 3
    processor.sta(0);

    // STA (addr) ; STA (0) = STA 3 = 'C'
    processor.lda(codeC + 0x10000, addressMode: AddressMode.immediate);
    processor.sta(0, addressMode: AddressMode.indirect);

    // LDA 3
    processor.lda(0);
    expect(processor.acc!.type, DataType.integer);
    expect(processor.acc!.value, 3);

    // LDA (0)
    processor.lda(0, addressMode: AddressMode.indirect);
    expect(processor.acc!.type, DataType.character);
    expect(processor.acc!.value, codeC);
  });
}
