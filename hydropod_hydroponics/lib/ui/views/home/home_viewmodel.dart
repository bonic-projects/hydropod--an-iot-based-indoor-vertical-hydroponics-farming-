import 'dart:async';

import 'package:hydropod_hydroponics/models/models.dart';
import 'package:hydropod_hydroponics/services/db_service.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
// import '../../setup_snackbar_ui.dart';

class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  // final _navigationService = locator<NavigationService>();
  final _dbService = locator<DbService>();

  DeviceReading? get node => _dbService.node;

  @override
  List<DbService> get reactiveServices => [_dbService];

  //Device data
  int servoMin = 25;
  int servoMax = 145;
  int stepperStep = 2;
  DeviceData _deviceData = DeviceData(
      servo: 0,
      stepper: 0,
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
    } else {
      _deviceData = DeviceData(
          servo: servoMin,
          stepper: stepperStep,
          isReadSensor: false,
          r1: false,
          r2: false,
          r3: false,
          r4: false);
    }
    setBusy(false);
  }

  void setServoRotation() {
    _deviceData.servo = _deviceData.servo == servoMin ? servoMax : servoMin;
    notifyListeners();
    setDeviceData();
  }

  void setStepper() {
    _deviceData.stepper = _deviceData.stepper + stepperStep;
    notifyListeners();
    setDeviceData();
  }

  void setIsReadSensor() {
    _deviceData.isReadSensor = !_deviceData.isReadSensor;
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

  //=========Chart============
  Timer? timer;
  List<ChartData>? chartData;
  late int count;
  ChartSeriesController? chartSeriesController;

  void onModelReady() {
    getDeviceData();
    count = 19;
    chartData = <ChartData>[];
    for (int i = 0; i < 19; i++) {
      chartData!.add(ChartData(i, 0));
    }
    timer =
        Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource);
  }

  void _updateDataSource(Timer timer) {
    chartData!.add(ChartData(count, node?.totalWaterFlow ?? 0));
    if (chartData!.length == 20) {
      chartData!.removeAt(0);
      chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
      );
    }
    count = count + 1;
  }

  @override
  void dispose() {
    timer?.cancel();
    chartData!.clear();
    chartSeriesController = null;
    super.dispose();
  }
}

class ChartData {
  ChartData(
    this.time,
    this.totalWaterFlow,
  );
  final int time;
  final int totalWaterFlow;
}
