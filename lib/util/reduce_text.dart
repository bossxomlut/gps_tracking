String reduceText(String text, {int maxLength = 8}) {
  if (text.length <= maxLength * 2) {
    return text;
  } else {
    String start = text.substring(0, maxLength);
    String end = text.substring(text.length - maxLength);
    return "$start...$end";
  }
}
