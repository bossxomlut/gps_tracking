import 'package:mp3_convert/util/parse_util.dart';

class ConvertData {
  final String uploadId;
  final double progress;
  final String? downloadId;

  ConvertData({
    required this.uploadId,
    required this.progress,
    this.downloadId,
  });

  factory ConvertData.fromMap(Map map) {
    return ConvertData(
      uploadId: map["uploadId"].toString(),
      progress: map["percent"].toString().parseDouble() ?? 0.0,
      downloadId: map["downloadId"]?.toString(),
    );
  }
}
