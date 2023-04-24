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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: _OtherButtons(
                text1: "Plant condition good",
                text2: "Plant condition bad",
                icon1: Icons.done,
                icon2: Icons.close,
                isTrue: model.node!.condition,
                onTap: model.setCondition,
              ),
            ),
          ),
          _OtherButtons(
            text1: "Rotate plants",
            text2: "Stop rotation",
            icon1: Icons.play_circle,
            icon2: Icons.stop_circle,
            isTrue: model.deviceData.stepper,
            onTap: model.setStepper,
          ),
          _OtherButtons(
            text1: "Move sensors down",
            text2: "Move sensors up",
            icon1: Icons.arrow_downward,
            icon2: Icons.arrow_upward,
            isTrue: model.deviceData.servo == model.servoMin,
            onTap: model.setServoRotation,
          ),
          _OtherButtons(
            text1: "Read sensor data",
            text2: "Stop reading sensor",
            icon1: Icons.play_circle,
            icon2: Icons.stop_circle,
            isTrue: !model.deviceData.isReadSensor,
            onTap: model.setIsReadSensor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ConditionButton(
                text1: "Light ON",
                text2: "Light OFF",
                isTrue: model.deviceData.r2,
                onTap: model.setR2,
              ),
              _ConditionButton(
                text1: "Pump ON",
                text2: "Pump OFF",
                isTrue: model.deviceData.r1,
                onTap: model.setR1,
              ),
              _ConditionButton(
                text1: "Fan ON",
                text2: "Fan OFF",
                isTrue: model.deviceData.r3,
                onTap: model.setR3,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WaterLevelMeter(value: model.node!.waterLevel),
              _TempMeter(value: model.node!.temp),
              _PhMeter(value: model.node!.ph),
              _ECMeter(value: model.node!.ec),
              // _WaterLevelMeter(),
              // _RainGageMeter(isRain: true),
              // _RainGageMeter(isRain: false),
            ],
          ),
          _GraphPlot(),
        ],
      ),
    );
  }
}

class _OtherButtons extends ViewModelWidget<HomeViewModel> {
  final String text1;
  final String text2;
  final IconData icon1;
  final IconData icon2;
  final bool isTrue;
  final VoidCallback onTap;
  const _OtherButtons({
    required this.text1,
    required this.text2,
    required this.icon1,
    required this.icon2,
    required this.isTrue,
    required this.onTap,
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isTrue ? Colors.teal : Colors.teal,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isTrue ? text1 : text2),
                    Icon(isTrue ? icon1 : icon2)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _buildThermometer(context);
  }
}

class _ConditionButton extends ViewModelWidget<HomeViewModel> {
  final String text1;
  final String text2;
  final bool isTrue;
  final VoidCallback onTap;
  const _ConditionButton({
    required this.text1,
    required this.text2,
    required this.isTrue,
    required this.onTap,
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isTrue ? Colors.red : Colors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(isTrue ? text1 : text2),
              ),
            ),
          ),
        ),
      );
    }

    return _buildThermometer(context);
  }
}

class _WaterLevelMeter extends ViewModelWidget<HomeViewModel> {
  final int value;
  const _WaterLevelMeter({required this.value, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      return Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Linear gauge to display celsius scale.
                SfLinearGauge(
                  minimum: 0,
                  maximum: 4095,
                  interval: 600,
                  minorTicksPerInterval: 0,
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
                        value: 4095,
                        enableAnimation: false,
                        position: LinearElementPosition.outside,
                        offset: 8,
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            'Water',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )),
                    LinearShapePointer(
                      value: 0,
                      markerAlignment: LinearMarkerAlignment.start,
                      shapeType: LinearShapePointerType.rectangle,
                      borderWidth: 1,
                      color: Colors.blue,
                      position: LinearElementPosition.cross,
                      width: 24,
                      height: 24,
                    ),
                  ],
                  barPointers: <LinearBarPointer>[
                    LinearBarPointer(
                      value: value.toDouble(),
                      enableAnimation: false,
                      thickness: 6,
                      edgeStyle: LinearEdgeStyle.endCurve,
                      color: Colors.blue,
                    )
                  ],
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text("$value"),
            ),
          ),
        ],
      ));
    }

    return _buildThermometer(context);
  }
}

class _PhMeter extends ViewModelWidget<HomeViewModel> {
  final double value;
  const _PhMeter({required this.value, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      final Brightness brightness = Theme.of(context).brightness;
      return Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Linear gauge to display celsius scale.
                SfLinearGauge(
                  minimum: 0,
                  maximum: 14,
                  interval: 1,
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
                        value: 14,
                        enableAnimation: false,
                        position: LinearElementPosition.outside,
                        offset: 8,
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            'pH',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )),
                    LinearShapePointer(
                      value: 0,
                      markerAlignment: LinearMarkerAlignment.start,
                      shapeType: LinearShapePointerType.rectangle,
                      borderWidth: 1,
                      color: Colors.deepPurpleAccent,
                      position: LinearElementPosition.cross,
                      width: 24,
                      height: 24,
                    ),
                  ],
                  barPointers: <LinearBarPointer>[
                    LinearBarPointer(
                      value: value,
                      enableAnimation: false,
                      thickness: 6,
                      edgeStyle: LinearEdgeStyle.endCurve,
                      color: Colors.deepPurpleAccent,
                    )
                  ],
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text("$value"),
            ),
          ),
        ],
      ));
    }

    return _buildThermometer(context);
  }
}

class _TempMeter extends ViewModelWidget<HomeViewModel> {
  final double value;
  const _TempMeter({required this.value, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      final Brightness brightness = Theme.of(context).brightness;
      return Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                                fontSize: 12, fontWeight: FontWeight.bold),
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
                      color: value > 30
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
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
                              right:
                                  BorderSide(width: 2.0, color: Colors.black),
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
              ],
            ),
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text("$value"),
            ),
          ),
        ],
      ));
    }

    return _buildThermometer(context);
  }
}

class _ECMeter extends ViewModelWidget<HomeViewModel> {
  final double value;
  const _ECMeter({required this.value, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      final Brightness brightness = Theme.of(context).brightness;
      return Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Linear gauge to display celsius scale.
                SfLinearGauge(
                  minimum: .5,
                  maximum: 3,
                  interval: .5,
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
                        value: 3,
                        enableAnimation: false,
                        position: LinearElementPosition.outside,
                        offset: 8,
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            'EC',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
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
                      color: value > 30
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
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
                              right:
                                  BorderSide(width: 2.0, color: Colors.black),
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
              ],
            ),
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text("$value"),
            ),
          ),
        ],
      ));
    }

    return _buildThermometer(context);
  }
}

// class _RainGageMeter extends ViewModelWidget<HomeViewModel> {
//   const _RainGageMeter({Key? key})
//       : super(key: key, reactive: true);
//
//   @override
//   Widget build(BuildContext context, HomeViewModel model) {
//     return Card(
//       child: Container(
//         height: 175,
//         width: 175,
//         child: SfRadialGauge(
//           title: GaugeTitle(
//               text: "Moisture",
//               textStyle: Theme.of(context).textTheme.bodyLarge!),
//           axes: <RadialAxis>[
//             RadialAxis(
//                 showLabels: false,
//                 showAxisLine: false,
//                 showTicks: false,
//                 minimum: 0,
//                 maximum: isRain ? 250 : 80,
//                 ranges: <GaugeRange>[
//                   GaugeRange(
//                     startValue: 0,
//                     endValue: isRain ? 62.5 : 20,
//                     color: Colors.green,
//                     sizeUnit: GaugeSizeUnit.factor,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                   ),
//                   GaugeRange(
//                     startValue: isRain ? 62.5 : 20,
//                     endValue: isRain ? 125 : 40,
//                     color: Colors.yellow,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                     sizeUnit: GaugeSizeUnit.factor,
//                   ),
//                   GaugeRange(
//                     startValue: isRain ? 125 : 40,
//                     endValue: isRain ? 187.5 : 60,
//                     color: Colors.deepOrangeAccent,
//                     sizeUnit: GaugeSizeUnit.factor,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                   ),
//                   GaugeRange(
//                     startValue: isRain ? 187.5 : 60,
//                     endValue: isRain ? 250 : 80,
//                     color: Colors.red,
//                     sizeUnit: GaugeSizeUnit.factor,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                   ),
//                 ],
//                 pointers: <GaugePointer>[
//                   NeedlePointer(
//                     value: isRain
//                         ? model.node?.ph.toDouble() ?? 0
//                         : model.node?.waterFLow.toDouble() ?? 0,
//                   )
//                 ])
//           ],
//         ),
//       ),
//     );
//   }
// }

class _GraphPlot extends ViewModelWidget<HomeViewModel> {
  const _GraphPlot({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Text("Total water flow",
                style: Theme.of(context).textTheme.bodyLarge!),
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
                    color: Colors.blue,
                    xValueMapper: (ChartData reading, _) => reading.time,
                    yValueMapper: (ChartData reading, _) =>
                        reading.totalWaterFlow,
                    animationDuration: 0,
                  ),
                  // LineSeries<ChartData, int>(
                  //   onRendererCreated: (ChartSeriesController controller) {
                  //     model.chartSeriesController = controller;
                  //   },
                  //   dataSource: model.chartData!,
                  //   color: const Color.fromRGBO(192, 108, 132, 1),
                  //   xValueMapper: (ChartData reading, _) => reading.time,
                  //   yValueMapper: (ChartData reading, _) => reading.y,
                  //   animationDuration: 0,
                  // ),
                  // LineSeries<ChartData, int>(
                  //   onRendererCreated: (ChartSeriesController controller) {
                  //     model.chartSeriesController = controller;
                  //   },
                  //   dataSource: model.chartData!,
                  //   color: const Color.fromRGBO(192, 108, 132, 1),
                  //   xValueMapper: (ChartData reading, _) => reading.time,
                  //   yValueMapper: (ChartData reading, _) => reading.z,
                  //   animationDuration: 0,
                  // ),
                ]),
          ],
        ),
      ),
    );
  }
}
