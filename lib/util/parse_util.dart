import 'dart:developer';

import 'package:intl/intl.dart';

extension ParseFromString on String? {
  int? parseInt() {
    if (this == null) {
      return null;
    }

    return int.tryParse(this!);
  }

  double? parseDouble() {
    if (this == null) {
      return null;
    }

    return double.tryParse(this!);
  }

  bool? parseBool() {
    if (this == null) {
      return null;
    }
    if (this == 'true' || this == '1') {
      return true;
    } else if (this == 'false' || this == '0') {
      return false;
    }

    return null;
  }

  DateTime? parseDate() {
    if (this == null) {
      return null;
    }
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(this!);
    } catch (_) {
      return null;
    }
  }

  DateTime? parseDate2() {
    if (this == null) {
      return null;
    }
    try {
      return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(this!);
    } catch (_) {
      return null;
    }
  }

  DateTime? parseDate3() {
    if (this == null) {
      return null;
    }
    try {
      return DateFormat("yyyy-MM-ddTHH:mm:ss").parse(this!);
    } catch (_) {
      return null;
    }
  }

  DateTime? parseDateTime() {
    if (this == null) {
      return null;
    }
    return DateTime.tryParse(this!);
  }
}

List<T>? parseList<T>(dynamic data, T Function(Map json) parseFunction) {
  if (data != null && data is List) {
    try {
      return data.map<T>((e) => parseFunction(e as Map)).toList();
    } catch (e, st) {
      log('error parsing: ${e.toString()}');
      log(st.toString());
    }
  }
  return null;
}

DateTime? parseDateFromTimeStamp(dynamic date) {
  try {
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date * 1000);
    } else if (date is String) {
      return DateTime.fromMillisecondsSinceEpoch(date.toString().parseInt()! * 1000);
    }
  } catch (e) {}

  return null;
}
