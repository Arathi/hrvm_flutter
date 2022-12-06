class RuntimeError implements Exception {
  String message;
  RuntimeError(this.message);
}

class CompileError implements Exception {
  String message;
  CompileError(this.message);
}
