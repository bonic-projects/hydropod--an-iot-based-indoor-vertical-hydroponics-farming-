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

  DeviceData? get node => _dbService.node;

  @override
  List<DbService> get reactiveServices => [_dbService];

  //=========Chart============
  Timer? timer;
  List<ChartData>? chartData;
  late int count;
  ChartSeriesController? chartSeriesController;

  void onModelReady() {
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
