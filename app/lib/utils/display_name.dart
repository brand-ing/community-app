String firstName(String? name, {String fallback = 'neighbor'}) {
  final trimmed = name?.trim() ?? '';
  return trimmed.isEmpty ? fallback : trimmed.split(RegExp(r'\s+')).first;
}
