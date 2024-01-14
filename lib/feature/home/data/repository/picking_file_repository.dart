import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/home/data/data_source/type_mapping_source.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class PickingFileRepository {
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType);
}

class PickingFileRepositoryImpl extends PickingFileRepository {
  final FileTypeMappingSource fileTypeMappingSource = FileTypeMappingSourceImpl(Mp3ApiRequest());
  final _MappingTypeStorage _mappingTypeStorage = _MappingTypeStorage();

  @override
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType) async {
    if (_mappingTypeStorage.checkContains(sourceType)) {
      return SuccessDataResult(_mappingTypeStorage.getValue(sourceType)!);
    }

    return fileTypeMappingSource.getMappingType(MappingTypeDto(type: sourceType)).then((response) {
      switch (response) {
        case SuccessApiResponse():
          final responseData = response.data;
          if (responseData is Map) {
            final value = ListMediaType.fromJson(responseData);
            _mappingTypeStorage.setValue(sourceType, value);
            return SuccessDataResult(value);
          }
        case FailureApiResponse():
          return FailureDataResult(FailureEntity(message: response.message));
      }

      return FailureDataResult(FailureEntity(message: response.message));
    });
  }
}

abstract class MappingStorage<K, V> {
  final Map<String, V> _mapping = {};
  void setValue(K key, V value) {
    _mapping[getKey(key)] = value;
  }

  bool checkContains(K key) {
    return _mapping.containsKey(key);
  }

  String getKey(K key);

  V? getValue(K key) {
    return _mapping[getKey(key)];
  }
}

class _MappingTypeStorage extends MappingStorage<String, ListMediaType> {
  @override
  String getKey(String key) {
    return key;
  }
}

class _SettingConvertFileStorage {
  static const String underscore = "_";

  //todo: need update later
  Map<String, ListMediaType> _mapping = {};

  void setFileType(String source, String destination, ListMediaType mediaType) {
    _mapping[getKey(source, destination)] = mediaType;
  }

  bool check(String source, String destination) {
    return _mapping.containsKey(getKey(source, destination));
  }

  String getKey(String source, String destination) {
    return "$source$underscore$destination";
  }

  ListMediaType? getMediaType(String source, String destination) {
    return _mapping[getKey(source, destination)];
  }
}

void main() async {
  final PickingFileRepository pickingFileRepository = PickingFileRepositoryImpl();
  final result = await pickingFileRepository.mappingType("mp4");

  switch (result) {
    case SuccessDataResult<FailureEntity, ListMediaType>():
      {
        final data = result.data;
        //handle this data
      }
    case FailureDataResult<FailureEntity, ListMediaType>():
      {
        final data = result.data;
        //show message or something else
      }
  }
}
