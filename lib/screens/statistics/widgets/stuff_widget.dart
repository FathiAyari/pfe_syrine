import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants.dart';
import '../../../services/statistics_services.dart';

class StuffScreen extends StatefulWidget {
  const StuffScreen({Key? key}) : super(key: key);

  @override
  State<StuffScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<StuffScreen> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    StatisticsServices.StuffStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7ea4f3),
        title: Text("Stuff's Statics"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ], color: Color(0xff7ea8f2), borderRadius: BorderRadius.circular(15)),
                height: Constants.screenHeight * 0.43,
                child: FutureBuilder(
                    future: StatisticsServices.StuffStats(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            SfCircularChart(
                              palette: <Color>[
                                Colors.lightBlue,
                                Colors.orange,
                                Colors.red,
                                Colors.green,
                                Colors.cyanAccent,
                              ],
                              title: ChartTitle(
                                text: 'Stuffs',
                              ),
                              legend: Legend(
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                  backgroundColor: Color.fromARGB(0, 143, 212, 122)),
                              tooltipBehavior: _tooltipBehavior,
                              series: <CircularSeries>[
                                PieSeries<StuffData, String>(
                                  dataSource: [
                                    StuffData(
                                      'Super Admins',
                                      snapshot.data["super_admins"],
                                    ),
                                    StuffData(
                                      'Admins',
                                      snapshot.data["admins"],
                                    ),
                                    StuffData(
                                      'Employees',
                                      snapshot.data["employees"],
                                    ),
                                    StuffData(
                                      'Companies',
                                      snapshot.data["companies"],
                                    ),
                                    StuffData(
                                      'Stock Managers',
                                      snapshot.data["stock_managers"],
                                    ),
                                  ],
                                  xValueMapper: (StuffData data, _) => data.label,
                                  yValueMapper: (StuffData data, _) => data.percentage,
                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                  enableTooltip: true,
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class StuffData {
  StuffData(this.label, this.percentage);
  final String label;
  final int percentage;
}
