/// Device Sensor Reading model
class DeviceReading {
  double ph;
  double waterFLow;
  int totalWaterFlow;
  int waterLevel;
  double temp;
  double ec;
  bool condition;
  DateTime lastSeen;

  DeviceReading({
    required this.ph,
    required this.waterFLow,
    required this.totalWaterFlow,
    required this.waterLevel,
    required this.temp,
    required this.lastSeen,
    required this.ec,
    required this.condition,
  });

  factory DeviceReading.fromMap(Map data) {
    return DeviceReading(
      ph: data['ph'] != null
          ? (data['ph'] % 1 == 0 ? data['ph'] + 0.1 : data['ph'])
          : 0.0,
      waterFLow: data['flowRate'] != null
          ? (data['flowRate'] % 1 == 0
              ? data['flowRate'] + 0.1
              : data['flowRate'])
          : 0.0,
      totalWaterFlow: data['totalMilliLitres'] ?? 0,
      waterLevel: data['wtr_level'] ?? 0,
      temp: data['temp'] != null
          ? (data['temp'] % 1 == 0 ? data['temp'] + 0.1 : data['temp'])
          : 0.0,
      ec: data['ec'] != null
          ? (data['ec'] % 1 == 0 ? data['ec'] + 0.1 : data['ec'])
          : 0.0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
      condition: data["condition"] ?? false,
    );
  }
}

/// Device control model
class DeviceData {
  int servo;
  bool stepper;
  bool isReadSensor;
  bool r1;
  bool r2;
  bool r3;
  bool r4;

  DeviceData({
    required this.servo,
    required this.stepper,
    required this.isReadSensor,
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      servo: data['servo'] != null ? data['servo'] : 0,
      stepper: data['stepper'] != null ? data['stepper'] : false,
      isReadSensor: data['isReadSensor'] ?? false,
      r1: data['r1'] ?? false,
      r2: data['r2'] ?? false,
      r3: data['r3'] ?? false,
      r4: data['r4'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'servo': servo,
        'stepper': stepper,
        'isReadSensor': isReadSensor,
        'r1': r1,
        'r2': r2,
        'r3': r3,
        'r4': r4,
      };
}
