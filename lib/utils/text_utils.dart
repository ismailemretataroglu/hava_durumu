String capitalizeTr(String text) {
  if (text.isEmpty) return text;
  final first = text[0] == 'i' ? 'İ' : text[0].toUpperCase();
  return first + text.substring(1);
}
