import 'package:flutter/material.dart';

import '../../core/data.dart';
import '../../core/data_queue.dart';
import '../../core/machine.dart';
import '../../core/processor.dart';
import '../../core/memory.dart';
import '../../core/instruction.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({super.key});

  @override
  State<StatefulWidget> createState() => MachinePageState();
}

class MachinePageState extends State<MachinePage> {
  late Machine machine;
  late TextEditingController _operandController;
  String _operand = "0";
  AddressMode _addressMode = AddressMode.absolute;

  Processor get processor => machine.processor;
  Memory get memory => machine.memory;

  @override
  void initState() {
    super.initState();
    machine = Machine(
      memoryWidth: 4,
      memoryHeight: 4,
      input: [1, 8, 'A', 88, 888, -888],
    );
    _operandController = TextEditingController(text: _operand);
  }

  @override
  void dispose() {
    _operandController.dispose();
    super.dispose();
  }

  void _instTest(String opcode) {
    setState(() {
      if (opcode == "PLA") {
        processor.pla();
      } else if (opcode == "PHA") {
        processor.pha();
      } else if (opcode == "LDA") {
        var address = int.parse(_operand);
        processor.lda(address, addressMode: _addressMode);
      } else if (opcode == "STA") {
        var address = int.parse(_operand);
        processor.sta(address, addressMode: _addressMode);
      } else if (opcode == "ADD") {
        var address = int.parse(_operand);
        processor.add(address, addressMode: _addressMode);
      } else if (opcode == "SUB") {
        var address = int.parse(_operand);
        processor.sub(address, addressMode: _addressMode);
      } else if (opcode == "INC") {
        var address = int.parse(_operand);
        processor.inc(address, addressMode: _addressMode);
      } else if (opcode == "DEC") {
        var address = int.parse(_operand);
        processor.dec(address, addressMode: _addressMode);
      } else if (opcode == "JMP") {
        var address = int.parse(_operand);
        processor.jmp(address);
      } else if (opcode == "BEQ") {
        var address = int.parse(_operand);
        processor.beq(address);
      } else if (opcode == "BMI") {
        var address = int.parse(_operand);
        processor.bmi(address);
      }
    });
  }

  void _onAccessModeChanged(AddressMode? mode) {
    if (mode != null) {
      setState(() {
        _addressMode = mode;
      });
    }
  }

  Widget buildDataBlock(
    Data data, {
    width = 32,
    height = 32,
  }) {
    late Color upperColor;
    late Color lowerColor;
    if (data.type == DataType.integer) {
      upperColor = const Color(0xFFA1CB5F);
      lowerColor = const Color(0xFF4F6036);
    } else {
      upperColor = const Color(0xFF8C8DC1);
      lowerColor = const Color(0xFF43445E);
    }
    var text = data.text;
    double fontSize = height * 0.4;
    switch (text.length) {
      case 1:
        fontSize = height * 0.7;
        break;
      case 2:
        fontSize = height * 0.6;
        break;
      case 3:
        fontSize = height * 0.5;
        break;
      case 4:
        fontSize = height * 0.4;
        break;
    }

    return Container(
      margin: const EdgeInsets.all(3),
      child: Column(
        children: [
          Container(
            color: upperColor,
            child: SizedBox(
              width: width * 1.0,
              height: height * 1.0,
              child: Center(
                  child: Text(
                text,
                style: TextStyle(
                  color: const Color(0xFF546B32),
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              )),
            ),
          ),
          Container(
            color: lowerColor,
            child: SizedBox(
              width: width * 1.0,
              height: height / 6.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQueue(String title, DataQueue queue) {
    List<Widget> dataBlocks = <Widget>[];
    for (var data in queue.datas) {
      dataBlocks.add(buildDataBlock(data));
    }

    return Container(
      padding: const EdgeInsets.all(3),
      color: const Color(0xFF382B23),
      width: 64,
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFB69B7D),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(children: dataBlocks),
          ),
        ],
      ),
    );
  }

  Widget buildMemory(BuildContext context, {double cellSize = 80}) {
    List<Row> rows = <Row>[];
    for (int y = 0; y < memory.height; y++) {
      List<Widget> cells = <Widget>[];
      for (int x = 0; x < memory.width; x++) {
        int addr = x + y * memory.width;
        Data? data = memory.read(addr);
        List<Widget> ws = <Widget>[];
        if (data != null) {
          ws.add(
            Positioned(
              top: 3,
              left: 20,
              child: buildDataBlock(data),
            ),
          );
        } else {
          //
        }
        ws.add(Positioned(
            bottom: 1,
            right: 3,
            child: Text(
              "$addr",
              style: TextStyle(
                color: const Color(0xFF7F5A3D),
                fontSize: cellSize * 0.2,
              ),
            )));

        Color? color = (x % 2 == y % 2) ? const Color(0xEE976B48) : null;
        cells.add(
          SizedBox(
            width: cellSize,
            height: cellSize,
            child: Container(
              color: color,
              child: Stack(
                children: ws,
              ),
            ),
          ),
        );
      }
      rows.add(Row(children: cells));
    }

    return Center(
      child: SizedBox(
        width: cellSize * memory.width,
        height: cellSize * memory.height,
        child: Container(
          color: const Color(0xCCA87653),
          child: Column(children: rows),
        ),
      ),
    );
  }

  Widget buildDebugger(BuildContext context) {
    List<DropdownMenuItem<AddressMode>> items = const [
      DropdownMenuItem(
        value: AddressMode.absolute,
        child: Text("绝对寻址 OPC addr"),
      ),
      DropdownMenuItem(
        value: AddressMode.immediate,
        child: Text("立即寻址 OPC #data"),
      ),
      DropdownMenuItem(
        value: AddressMode.indirect,
        child: Text("间接寻址 OPC (addr)"),
      ),
    ];

    const Color queueInstColor = Color(0xFF9CB65B);
    const Color memoryInstColor = Color(0xFFC96A54);
    const Color arithmeticInstColor = Color(0xFFC68D62);
    const Color jumpInstColor = Color(0xFF8D8DC1);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // 操作数
          Row(
            children: [
              const Text("操作数："),
              SizedBox(
                width: 128,
                child: TextField(
                  controller: _operandController,
                  onChanged: (value) {
                    setState(() {
                      print("操作数改变为：$value");
                      _operand = value;
                    });
                  },
                ),
              ),
              DropdownButton(
                value: _addressMode,
                items: items,
                onChanged: _onAccessModeChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 队列指令
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _instTest("PLA"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    queueInstColor,
                  ),
                ),
                child: const Text("PLA"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _instTest("PHA"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    queueInstColor,
                  ),
                ),
                child: const Text("PHA"),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 内存读写指令
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _instTest("LDA"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    memoryInstColor,
                  ),
                ),
                child: const Text("LDA"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _instTest("STA"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    memoryInstColor,
                  ),
                ),
                child: const Text("STA"),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 算术运算指令
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _instTest("ADD"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    arithmeticInstColor,
                  ),
                ),
                child: const Text("ADD"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _instTest("SUB"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    arithmeticInstColor,
                  ),
                ),
                child: const Text("SUB"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _instTest("INC"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    arithmeticInstColor,
                  ),
                ),
                child: const Text("INC"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _instTest("DEC"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    arithmeticInstColor,
                  ),
                ),
                child: const Text("DEC"),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 跳转指令
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _instTest("JMP"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    jumpInstColor,
                  ),
                ),
                child: const Text("JMP"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _instTest("BEQ"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    jumpInstColor,
                  ),
                ),
                child: const Text("BEQ"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _instTest("BMI"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    jumpInstColor,
                  ),
                ),
                child: const Text("BMI"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    Widget accBlock = (processor.acc != null)
        ? buildDataBlock(processor.acc!)
        : SizedBox(
            width: 32,
            height: 32 + 32 / 6.0,
            child: Container(
              color: Colors.grey,
            ),
          );

    return Row(
      children: [
        buildQueue("INBOX", machine.inbox),
        Expanded(
          flex: 3,
          child: Container(
            color: const Color(0xFFC29170),
            child: Column(
              children: [
                SizedBox(height: 128, child: Center(child: accBlock)),
                const SizedBox(height: 10),
                Expanded(child: buildMemory(context)),
              ],
            ),
          ),
        ),
        buildQueue("OUTBOX", machine.outbox),
        Expanded(
          flex: 2,
          child: buildDebugger(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }
}
