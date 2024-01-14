import 'package:uuid/uuid.dart';

abstract class GenerateString {
  String getString();
}

class UUIDGenerateString extends GenerateString {
  final Uuid _uuid = const Uuid();
  @override
  String getString() {
    return _uuid.v1();
  }
}
