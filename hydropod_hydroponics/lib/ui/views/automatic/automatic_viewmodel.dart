import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/db_service.dart';
// import '../../setup_snackbar_ui.dart';

class TrainViewModel extends ReactiveViewModel {
  final log = getLogger('AutomaticViewModel');

  final _snackBarService = locator<SnackbarService>();
  final _dbService = locator<DbService>();

  DeviceReading? get node => _dbService.node;
  DeviceData2? get node2 => _dbService.node2;

  @override
  List<DbService> get reactiveServices => [_dbService];

  //Device data
  DeviceData _deviceData = DeviceData(
      servo: 0,
      stepper: false,
      isReadSensor: false,
      r1: false,
      r2: false,
      r3: false,
      r4: false);
  DeviceData get deviceData => _deviceData;

  void setDeviceData() {
    _dbService.setDeviceData(_deviceData);
  }

  void getDeviceData() async {
    setBusy(true);
    DeviceData? deviceData = await _dbService.getDeviceData();
    if (deviceData != null) {
      _deviceData = DeviceData(
        servo: deviceData.servo,
        stepper: deviceData.stepper,
        isReadSensor: deviceData.isReadSensor,
        r1: deviceData.r1,
        r2: deviceData.r2,
        r3: deviceData.r3,
        r4: deviceData.r4,
      );
    }
    setBusy(false);
  }

  void onModelReady() async {
    getDeviceData();
  }

  bool _isRotating = false;
  bool get isRotating => _isRotating;
  bool _isReachedPlant = false;
  bool get isReachedPlant => _isReachedPlant;

  Future rotate() async {
    _isRotating = true;
    notifyListeners();
    sortItems();
  }

  void stopRotation() {
    log.i("Stopping rotation");
    _isRotating = false;
    notifyListeners();
  }

  void setDefaultPosition() {
    log.i("Default position");
    _deviceData = DeviceData(
        servo: servoMin,
        stepper: false,
        isReadSensor: false,
        r1: false,
        r2: false,
        r3: false,
        r4: false);
    ;
    setDeviceData();
    notifyListeners();
  }

  Future<void> sortItems() async {
    setDefaultPosition();
    while (_isRotating) {
      setIsReadSensor(true);
      notifyListeners();
      log.i("Rotating");
      setStepper(true);

      if (node!.ir) {
        log.i("Plant is here");
        setStepper(false);
        await Future.delayed(Duration(seconds: 2));
        await alignPlantAndReadData();
        // stopSorting();
      } else {
        while (!node!.ir) {
          log.i('No plant');
          setStepper(true);
          await Future.delayed(Duration(milliseconds: 100));
        }
        // setDefaultPosition();
        // stepperStop();
      }
    }
    setStepper(false);
    setIsReadSensor(false);
  }

  Future alignPlantAndReadData() async {
    log.i("Processing");
    _isReachedPlant = true;
    notifyListeners();
    while (_isReachedPlant) {
      // rightDirection();
      await Future.delayed(Duration(seconds: 3));
      setServoRotation(false);
      await Future.delayed(Duration(seconds: 10));
      setServoRotation(true);
      await Future.delayed(Duration(seconds: 1));
      setDefaultPosition();
      _isReachedPlant = false;
      notifyListeners();
    }
  }

  void setServoRotation(bool isUp) {
    _deviceData.servo = !isUp ? servoMax : servoMin;
    notifyListeners();
    setDeviceData();
  }

  void setStepper(bool isRotate) {
    _deviceData.stepper = isRotate;
    notifyListeners();
    setDeviceData();
  }

  void setIsReadSensor(bool isRead) {
    _deviceData.isReadSensor = isRead;
    notifyListeners();
    setDeviceData();
  }

  void setR1() {
    _deviceData.r1 = !_deviceData.r1;
    notifyListeners();
    setDeviceData();
  }

  void setR2() {
    _deviceData.r2 = !_deviceData.r2;
    notifyListeners();
    setDeviceData();
  }

  void setR3() {
    _deviceData.r3 = !_deviceData.r3;
    notifyListeners();
    setDeviceData();
  }

  void setR4() {
    _deviceData.r4 = !_deviceData.r4;
    notifyListeners();
    setDeviceData();
  }
}
