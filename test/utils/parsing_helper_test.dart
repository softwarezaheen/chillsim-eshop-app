import "package:esim_open_source/utils/parsing_helper.dart";
import "package:flutter_test/flutter_test.dart";

// ignore_for_file: type=lint
class TestModel {
  TestModel({required this.name, required this.age});

  factory TestModel.fromJson({dynamic json}) {
    return TestModel(
      name: json["name"] as String,
      age: json["age"] as int,
    );
  }
  final String name;
  final int age;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

Future<void> main() async {
  group("ParsingHelper Tests", () {
    group("fromJsonListTypedNamed", () {
      test("parses valid JSON list correctly", () {
        final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
          <String, dynamic>{"name": "John", "age": 25},
          <String, dynamic>{"name": "Jane", "age": 30},
        ];

        final List<TestModel> result = fromJsonListTypedNamed<TestModel>(
          parser: TestModel.fromJson,
          json: jsonList,
        );

        expect(result, hasLength(2));
        expect(result[0].name, equals("John"));
        expect(result[0].age, equals(25));
        expect(result[1].name, equals("Jane"));
        expect(result[1].age, equals(30));
      });

      test("handles empty JSON list", () {
        final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[];

        final List<TestModel> result = fromJsonListTypedNamed<TestModel>(
          parser: TestModel.fromJson,
          json: jsonList,
        );

        expect(result, isEmpty);
      });

      test("handles single item JSON list", () {
        final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
          <String, dynamic>{"name": "Single", "age": 42},
        ];

        final List<TestModel> result = fromJsonListTypedNamed<TestModel>(
          parser: TestModel.fromJson,
          json: jsonList,
        );

        expect(result, hasLength(1));
        expect(result[0].name, equals("Single"));
        expect(result[0].age, equals(42));
      });
    });

    group("fromJsonListTyped", () {
      test("parses valid JSON list correctly", () {
        final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
          <String, dynamic>{"name": "Alice", "age": 28},
          <String, dynamic>{"name": "Bob", "age": 35},
        ];

        final List<TestModel> result = fromJsonListTyped<TestModel>(
          parser: TestModel.fromJson,
          json: jsonList,
        );

        expect(result, hasLength(2));
        expect(result[0].name, equals("Alice"));
        expect(result[0].age, equals(28));
        expect(result[1].name, equals("Bob"));
        expect(result[1].age, equals(35));
      });

      test("handles empty JSON list", () {
        final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[];

        final List<TestModel> result = fromJsonListTyped<TestModel>(
          parser: TestModel.fromJson,
          json: jsonList,
        );

        expect(result, isEmpty);
      });

      test("handles large JSON list", () {
        final List<Map<String, dynamic>> jsonList = List.generate(
          100,
          (int index) =>
              <String, dynamic>{"name": "User$index", "age": 20 + index},
        );

        final List<TestModel> result = fromJsonListTyped<TestModel>(
          parser: TestModel.fromJson,
          json: jsonList,
        );

        expect(result, hasLength(100));
        expect(result[0].name, equals("User0"));
        expect(result[99].name, equals("User99"));
        expect(result[99].age, equals(119));
      });
    });
  });
}
