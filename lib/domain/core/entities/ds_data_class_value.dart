
/// наименования классов команд передаваемых в DataServer
enum DsDataClassValue {
  requestAll('requestAll'),
  requestList('requestList'),
  requestTime('requestTime'),
  requestAlarms('requestAlarms'),
  requestPath('requestPath'),
  syncTime('syncTime'),
  commonCmd('commonCmd'),
  commonData('commonData');
  const DsDataClassValue(this.value);
  final String value;
}
