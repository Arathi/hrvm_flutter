import 'data.dart';

import 'processor.dart';
import 'memory.dart';
import 'data_queue.dart';

class Machine {
  late Processor processor;
  late Memory memory;
  late DataQueue inbox;
  late DataQueue outbox;
}

