import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

class FakeContext extends Fake implements BuildContext {
  @override
  bool get mounted => true;
}
