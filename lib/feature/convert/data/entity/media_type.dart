import 'package:equatable/equatable.dart';

class MediaType extends Equatable implements Comparable<MediaType> {
  final String name;

  const MediaType({required this.name});

  factory MediaType.fromString(String value) {
    return MediaType(name: value);
  }

  @override
  List<Object?> get props => [
        name,
      ];

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
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
