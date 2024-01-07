import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/feature/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> with SafeEmit {
  HomeCubit() : super(HomeEmptyState());

  void setPickedFiles(List<String> files) {
    emit(PickedFileState(files: files));
  }
}
