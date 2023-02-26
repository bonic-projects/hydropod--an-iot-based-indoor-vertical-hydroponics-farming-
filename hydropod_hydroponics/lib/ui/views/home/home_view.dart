import 'package:flutter/material.dart';
import 'package:hydropod_hydroponics/ui/smart_widgets/online_status.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Hydropod'),
              centerTitle: true,
              actions: [IsOnlineWidget()],
            ),
            body: model.node != null ? const _HomeBody() : Text("No data"));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class _HomeBody2 extends ViewModelWidget<HomeViewModel> {
  const _HomeBody2({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Container(
      width: 400,
      height: 400,
      child: model.node != null
          ? Text(model.node!.temp.toString())
          : Text("No data"),
    );
  }
}

class _HomeBody extends ViewModelWidget<HomeViewModel> {
  const _HomeBody({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // _Alert(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TempMeter(value: model.node!.temp)
            // _RainGageMeter(isRain: true),
            // _RainGageMeter(isRain: false),
          ],
        ),
        // _GraphPlot(),
      ],
    );
  }
}

// class _Alert extends ViewModelWidget<HomeViewModel> {
//   const _Alert({Key? key}) : super(key: key, reactive: true);
//
//   @override
//   Widget build(BuildContext context, HomeViewModel model) {
//     Color getColor(String? color) {
//       if (color == "white")
//         return Colors.white;
//       else if (color == "green")
//         return Colors.green;
//       else if (color == "yellow")
//         return Colors.yellow;
//       else if (color == "orange")
//         return Colors.orange;
//       else if (color == "red")
//         return Colors.red;
//       else if (color == "magenta")
//         return Colors.purple;
//       else
//         return Colors.white;
//     }
//
//     return Card(
//       child: Center(
//           child: Column(
//         children: [
//           Text(
//             "Alert",
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 22.0, top: 10),
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black),
//                   shape: BoxShape.circle,
//                   color: getColor(model.node?.color)),
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }

class _TempMeter extends ViewModelWidget<HomeViewModel> {
  final double value;
  const _TempMeter({required this.value, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      final Brightness brightness = Theme.of(context).brightness;
      return Center(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// Linear gauge to display celsius scale.
          SfLinearGauge(
            minimum: -20,
            maximum: 50,
            interval: 10,
            minorTicksPerInterval: 2,
            axisTrackExtent: 23,
            axisTrackStyle: LinearAxisTrackStyle(
                thickness: 12,
                color: Colors.white,
                borderWidth: 1,
                edgeStyle: LinearEdgeStyle.bothCurve),
            tickPosition: LinearElementPosition.outside,
            labelPosition: LinearLabelPosition.outside,
            orientation: LinearGaugeOrientation.vertical,
            markerPointers: <LinearMarkerPointer>[
              LinearWidgetPointer(
                  markerAlignment: LinearMarkerAlignment.end,
                  value: 50,
                  enableAnimation: false,
                  position: LinearElementPosition.outside,
                  offset: 8,
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      '°C',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  )),
              LinearShapePointer(
                value: -20,
                markerAlignment: LinearMarkerAlignment.start,
                shapeType: LinearShapePointerType.circle,
                borderWidth: 1,
                borderColor: brightness == Brightness.dark
                    ? Colors.white30
                    : Colors.black26,
                color: Colors.teal,
                position: LinearElementPosition.cross,
                width: 24,
                height: 24,
              ),
              LinearShapePointer(
                value: -20,
                markerAlignment: LinearMarkerAlignment.start,
                shapeType: LinearShapePointerType.circle,
                borderWidth: 6,
                borderColor: Colors.transparent,
                color: value > 30
                    ? const Color(0xffFF7B7B)
                    : const Color(0xff0074E3),
                position: LinearElementPosition.cross,
                width: 24,
                height: 24,
              ),
              LinearWidgetPointer(
                  value: -20,
                  markerAlignment: LinearMarkerAlignment.start,
                  child: Container(
                    width: 10,
                    height: 3.4,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 2.0, color: Colors.black),
                        right: BorderSide(width: 2.0, color: Colors.black),
                      ),
                      color: value > 30
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
                    ),
                  )),
              // LinearWidgetPointer(
              //     value: value,
              //     enableAnimation: false,
              //     position: LinearElementPosition.outside,
              //     // onChanged: (dynamic value) {
              //     //   setState(() {
              //     //     _meterValue = value as double;
              //     //   });
              //     // },
              //     child: Container(
              //         width: 16,
              //         height: 12,
              //         transform: Matrix4.translationValues(4, 0, 0.0),
              //         child: Image.asset(
              //           'images/triangle_pointer.png',
              //           color: value > 30
              //               ? const Color(0xffFF7B7B)
              //               : const Color(0xff0074E3),
              //         ))),
              LinearShapePointer(
                value: value,
                width: 20,
                height: 20,
                enableAnimation: false,
                color: Colors.transparent,
                position: LinearElementPosition.cross,
                // onChanged: (dynamic value) {
                //   setState(() {
                //     _meterValue = value as double;
                //   });
                // },
              )
            ],
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: value,
                enableAnimation: false,
                thickness: 6,
                edgeStyle: LinearEdgeStyle.endCurve,
                color: value > 30
                    ? const Color(0xffFF7B7B)
                    : const Color(0xff0074E3),
              )
            ],
          ),

          /// Linear gauge to display Fahrenheit  scale.
          Container(
              transform: Matrix4.translationValues(-6, 0, 0.0),
              child: SfLinearGauge(
                maximum: 120,
                showAxisTrack: false,
                interval: 20,
                minorTicksPerInterval: 0,
                axisTrackExtent: 24,
                axisTrackStyle: const LinearAxisTrackStyle(thickness: 0),
                orientation: LinearGaugeOrientation.vertical,
                markerPointers: <LinearMarkerPointer>[
                  LinearWidgetPointer(
                      markerAlignment: LinearMarkerAlignment.end,
                      value: 120,
                      position: LinearElementPosition.inside,
                      offset: 6,
                      enableAnimation: false,
                      child: SizedBox(
                        height: 30,
                        child: Text(
                          '°F',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      )),
                ],
              ))
        ],
      ));
    }

    return Card(
      child: _buildThermometer(context),
    );
  }
}

class _RainGageMeter extends ViewModelWidget<HomeViewModel> {
  final bool isRain;
  const _RainGageMeter({required this.isRain, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Card(
      child: Container(
        height: 175,
        width: 175,
        child: SfRadialGauge(
          title: GaugeTitle(
              text: isRain ? "Rain" : "Moisture",
              textStyle: Theme.of(context).textTheme.bodyLarge!),
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showAxisLine: false,
                showTicks: false,
                minimum: 0,
                maximum: isRain ? 250 : 80,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: isRain ? 62.5 : 20,
                    color: Colors.green,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.5,
                    endWidth: 0.5,
                  ),
                  GaugeRange(
                    startValue: isRain ? 62.5 : 20,
                    endValue: isRain ? 125 : 40,
                    color: Colors.yellow,
                    startWidth: 0.5,
                    endWidth: 0.5,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: isRain ? 125 : 40,
                    endValue: isRain ? 187.5 : 60,
                    color: Colors.deepOrangeAccent,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.5,
                    endWidth: 0.5,
                  ),
                  GaugeRange(
                    startValue: isRain ? 187.5 : 60,
                    endValue: isRain ? 250 : 80,
                    color: Colors.red,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.5,
                    endWidth: 0.5,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: isRain
                        ? model.node?.ph.toDouble() ?? 0
                        : model.node?.waterFLow.toDouble() ?? 0,
                  )
                ])
          ],
        ),
      ),
    );
  }
}

class _GraphPlot extends ViewModelWidget<HomeViewModel> {
  const _GraphPlot({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Text("Gyroscope", style: Theme.of(context).textTheme.bodyLarge!),
            SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis:
                    NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0)),
                series: <LineSeries<ChartData, int>>[
                  LineSeries<ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      model.chartSeriesController = controller;
                    },
                    dataSource: model.chartData!,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (ChartData reading, _) => reading.time,
                    yValueMapper: (ChartData reading, _) => reading.x,
                    animationDuration: 0,
                  ),
                  LineSeries<ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      model.chartSeriesController = controller;
                    },
                    dataSource: model.chartData!,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (ChartData reading, _) => reading.time,
                    yValueMapper: (ChartData reading, _) => reading.y,
                    animationDuration: 0,
                  ),
                  LineSeries<ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      model.chartSeriesController = controller;
                    },
                    dataSource: model.chartData!,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (ChartData reading, _) => reading.time,
                    yValueMapper: (ChartData reading, _) => reading.z,
                    animationDuration: 0,
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
