import 'package:mp3_convert/widget/file_picker.dart';

class SettingFile extends AppFile {
  SettingFile({
    required super.name,
    required super.path,
    this.destinationType,
  });

  final String? destinationType;

  SettingFile copyWith({
    String? name,
    String? path,
    String? destinationType,
  }) {
    return SettingFile(
      name: name ?? this.name,
      path: path ?? this.path,
      destinationType: destinationType ?? this.destinationType,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        destinationType,
      ];
}
