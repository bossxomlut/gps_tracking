class MediaType {
  final String name;

  MediaType({required this.name});

  factory MediaType.fromString(String value) {
    return MediaType(name: value);
  }
}

class ListMediaType {
  final List<MediaType> types;

  ListMediaType({required this.types});

  factory ListMediaType.fromJson(Map json) {
    final mediaTypes = json["mediaTypes"];

    if (mediaTypes is List) {
      return ListMediaType(types: mediaTypes.map((e) => e.toString()).map(MediaType.fromString).toList());
    }

    return ListMediaType(types: []);
  }
}
