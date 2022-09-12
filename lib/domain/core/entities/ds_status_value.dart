
/// статусы точки данных
enum DsStatusValue {
  ok(0),
  obsolete(2),
  timeInvalid(3),
  invalid(10);
  const DsStatusValue(this.value);
  final int value;
}
