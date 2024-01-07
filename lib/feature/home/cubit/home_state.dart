import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  final List<String>? files;

  const HomeState({this.files});

  @override
  List<Object?> get props => [
        files.hashCode,
      ];
}

class HomeEmptyState extends HomeState {}

class PickedFileState extends HomeState {
  const PickedFileState({required List<String> files}) : super(files: files);
}
