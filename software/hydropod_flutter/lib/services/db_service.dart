import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

import '../app/app.logger.dart';
import '../models/models.dart';

class DbService with ReactiveServiceMixin {
  final log = getLogger('RealTimeDB_Service');

  FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceReading? _node;
  DeviceReading? get node => _node;
  DeviceData2? _node2;
  DeviceData2? get node2 => _node2;

  void setupNodeListening() {
    DatabaseReference starCountRef =
        _db.ref('/devices/PhHdzpmj4xUZT6wWELcs1FroV513/reading');
    starCountRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        _node = DeviceReading.fromMap(event.snapshot.value as Map);
        // log.v(_node?.lastSeen); //data['time']
        notifyListeners();
      }
    });
  }

  Future<DeviceData?> getDeviceData() async {
    DatabaseReference dataRef =
        _db.ref('/devices/PhHdzpmj4xUZT6wWELcs1FroV513/data');
    final value = await dataRef.once();
    if (value.snapshot.exists) {
      return DeviceData.fromMap(value.snapshot.value as Map);
    }
    return null;
  }

  void setDeviceData(DeviceData data) {
    DatabaseReference dataRef =
        _db.ref('/devices/PhHdzpmj4xUZT6wWELcs1FroV513/data');
    dataRef.update(data.toJson());
  }

  void setCondition(bool condition) {
    DatabaseReference dataRef =
        _db.ref('/devices/PhHdzpmj4xUZT6wWELcs1FroV513/reading');
    dataRef.update({"condition": condition});
  }

  void setupNode2Listening() {
    DatabaseReference starCountRef =
        _db.ref('/devices/PhHdzpmj4xUZT6wWELcs1FroV513/reading2');
    starCountRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        _node2 = DeviceData2.fromMap(event.snapshot.value as Map);
        // log.v(_node?.lastSeen); //data['time']
        notifyListeners();
      }
    });
  }
}
