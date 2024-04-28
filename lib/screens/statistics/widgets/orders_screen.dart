import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../services/statistics_services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<OrdersScreen> {
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
        backgroundColor: Color(0xffed6591),
        title: Text("Orders's Statics"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: StatisticsServices.OrdersStats(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<OrdersData> chartData = [];
            for (var data in snapshot.data) {
              chartData.add(OrdersData(date: data.date, quantity: data.quantity));
            }
            return Padding(padding: const EdgeInsets.all(8.0), child: Text("test")

                /*SfCartesianChart(
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
                  series: <ChartSeries<OrdersData, DateTime>>[
                    ColumnSeries<OrdersData, DateTime>(
                        color: Color(0xffed6591),
                        dataSource: chartData,
                        xValueMapper: (OrdersData data, _) => data.date,
                        yValueMapper: (OrdersData data, _) => data.quantity)
                  ]),*/
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

class OrdersData {
  OrdersData({required this.date, required this.quantity});

  final DateTime date;
  final int quantity;

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      date: DateTime.parse(json['date']),
      quantity: json['quantity'],
    );
  }
}
