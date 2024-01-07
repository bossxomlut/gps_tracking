part of 'base_cubit.dart';

mixin SafeEmit<T> on Cubit<T> {
  @override
  void emit(state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
