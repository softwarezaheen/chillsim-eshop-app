// models/esim_arguments.dart

class EsimArguments {
  const EsimArguments({
    required this.id,
    required this.name,
    required this.type,
  });
  final String id;
  final String name;
  final String type;

  EsimArguments copyWith({
    String? code,
    String? name,
    String? type,
  }) {
    return EsimArguments(
      id: code ?? id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}

class EsimArgumentType {
  static const String region = "Region";
  static const String country = "Country";
}
