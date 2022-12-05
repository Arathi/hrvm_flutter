import 'processor.dart';
import 'memory.dart';
import 'data_queue.dart';

class Machine {
  late Processor processor;
  late Memory memory;
  late DataQueue inbox;
  late DataQueue outbox;

  Machine({int memoryWidth = 1, int memoryHeight = 1, List<dynamic> input = const [],}) {
    processor = Processor(this);
    memory = Memory(width: memoryWidth, height: memoryHeight);
    inbox = DataQueue.of(input);
    outbox = DataQueue();
  }
}
