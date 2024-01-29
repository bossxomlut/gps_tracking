extension IsNotNullAndNotEmpty on Iterable? {
  bool get isNotNullAndNotEmpty => _isNotNullAndNotEmpty();

  bool _isNotNullAndNotEmpty() {
    return this != null && (this?.isNotEmpty ?? false);
  }
}
