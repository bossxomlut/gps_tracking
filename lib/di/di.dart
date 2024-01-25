import 'package:get_it/get_it.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source_impl.dart';
import 'package:mp3_convert/feature/convert/data/data_source/type_mapping_source.dart';
import 'package:mp3_convert/feature/convert/data/data_source/type_mapping_source_impl.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository_impl.dart';
import 'package:mp3_convert/feature/convert/data/repository/picking_file_repository.dart';
import 'package:mp3_convert/feature/convert/data/repository/picking_file_repository_impl.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';

final di = GetIt.instance;

void registerDI() {
  //api request
  di.registerFactory<UploadApiRequest>(() => UploadApiRequest());
  di.registerFactory<Mp3ApiRequest>(() => Mp3ApiRequest());

  //data source
  di.registerFactory<FileDataSource>(() => FileDataSourceImpl());
  di.registerFactory<FileTypeMappingSource>(() => FileTypeMappingSourceImpl());

  //repository
  di.registerFactory<PickingFileRepository>(() => PickingFileRepositoryImpl());
  di.registerFactory<MappingTypeStorage>(() => MappingTypeStorage());
  di.registerFactory<MappingTypeNameStorage>(() => MappingTypeNameStorage());
  di.registerFactory<ConvertFileRepository>(() => ConvertFileRepositoryImpl());
}
