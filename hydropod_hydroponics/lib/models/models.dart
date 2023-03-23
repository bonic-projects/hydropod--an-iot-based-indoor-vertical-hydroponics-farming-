/// Institution model
class DeviceData {
  double ph;
  int waterFLow;
  int totalWaterFlow;
  int waterLevel;
  double temp;
  double ec;
  DateTime lastSeen;

  DeviceData({
    required this.ph,
    required this.waterFLow,
    required this.totalWaterFlow,
    required this.waterLevel,
    required this.temp,
    required this.lastSeen,
    required this.ec,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      ph: data['ph'] != null
          ? (data['ph'] % 1 == 0 ? data['ph'] + 0.1 : data['ph'])
          : 0.0,
      waterFLow: data['flowRate'] ?? 0,
      totalWaterFlow: data['totalMilliLitres'] ?? 0,
      waterLevel: data['wtr_level'] ?? 0,
      temp: data['temp'] != null ? data['temp'] : 0,
      ec: data['ec'] != null
          ? (data['ec'] % 1 == 0 ? data['ec'] + 0.1 : data['ec'])
          : 0.0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}
