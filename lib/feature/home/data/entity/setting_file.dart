import 'package:mp3_convert/widget/file_picker.dart';

class SettingFile extends AppFile {
  SettingFile({
    required super.name,
    required super.path,
    this.destinationType,
    this.uploadId,
  });

  final String? destinationType;
  final String? uploadId;

  SettingFile copyWith({
    String? name,
    String? path,
    String? destinationType,
    String? uploadId,
  }) {
    return SettingFile(
      name: name ?? this.name,
      path: path ?? this.path,
      destinationType: destinationType ?? this.destinationType,
      uploadId: uploadId ?? this.uploadId,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        destinationType,
      ];
}
