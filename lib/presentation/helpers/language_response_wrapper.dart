class LanguageResponseWrapper<T> {
  LanguageResponseWrapper({
    required this.code,
    required this.data,
  });

  final String code;
  final T data;
}
