import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../services/statistics_services.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  State<PlanningScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<PlanningScreen> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: "",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff69e5c8),
        title: Text("Planning's Statics"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: StatisticsServices.PlanningStats(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<PlanningsData> chartData = [];
            for (var data in snapshot.data) {
              chartData.add(PlanningsData(date: data.date, quantity: data.quantity));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "test") /*SfCartesianChart(
                  enableSideBySideSeriesPlacement: false,
                  tooltipBehavior: _tooltipBehavior,
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: "Quantity"),
                  ),
                  primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.months,
                    title: AxisTitle(
                      text: "Date",
                    ),
                  ),
                  series: <ChartSeries<PlanningsData, DateTime>>[
                    // Renders line chart
                    ColumnSeries<PlanningsData, DateTime>(
                        color: Color(0xff69e5c8),
                        dataSource: chartData,
                        xValueMapper: (PlanningsData data, _) => data.date,
                        yValueMapper: (PlanningsData data, _) => data.quantity)
                  ])*/
              ,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }
}

class PlanningsData {
  PlanningsData({required this.date, required this.quantity});

  final DateTime date;
  final int quantity;

  factory PlanningsData.fromJson(Map<String, dynamic> json) {
    return PlanningsData(
      date: DateTime.parse(json['date']),
      quantity: json['quantity'],
    );
  }
}
