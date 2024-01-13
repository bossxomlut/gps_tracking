sealed class DataResult<F, S> {
  DataResult();
}

final class SuccessDataResult<F, S> extends DataResult<F, S> {
  final S data;

  SuccessDataResult(this.data);
}

final class FailureDataResult<F, S> extends DataResult<F, S> {
  final F data;

  FailureDataResult(this.data);
}
