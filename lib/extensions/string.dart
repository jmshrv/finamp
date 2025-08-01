extension BlankString on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;
}

extension NullableEmptyString on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension NullableBlankString on String? {
  bool get isNullOrBlank => this == null || this!.isBlank;
}
