import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/models/product.dart';
import 'package:pfe_syrine/services/statistics_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<ProductsScreen> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff0a55f),
        title: Text("Products Statics"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: StatisticsServices.ProductsStats(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length != 0) {
                List<Product> products = [];
                for (var product in snapshot.data) {
                  products.add(product);
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color(0xfff0a55f).withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ], color: Color(0xfff0a55f).withOpacity(0.4), borderRadius: BorderRadius.circular(15)),
                        height: Constants.screenHeight * 0.5,
                        child: Column(
                          children: [
                            SfCircularChart(
                              palette: <Color>[
                                Colors.green,
                                Colors.red,
                              ],
                              title: ChartTitle(
                                text: '${products[index].name}',
                                textStyle:
                                    TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                              ),
                              legend: Legend(
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                  backgroundColor: Color.fromARGB(0, 143, 212, 122)),
                              tooltipBehavior: _tooltipBehavior,
                              series: <CircularSeries>[
                                PieSeries<ProductsData, String>(
                                  dataSource: [
                                    ProductsData(
                                      'Available space',
                                      products[index].availableSpace,
                                    ),
                                    ProductsData(
                                      'Used space',
                                      products[index].quantity,
                                    ),
                                  ],
                                  xValueMapper: (ProductsData data, _) => data.label,
                                  yValueMapper: (ProductsData data, _) => data.percentage,
                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                  enableTooltip: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Center(
                          child: Column(
                        children: [
                          Lottie.asset("assets/empty.json"),
                          Text(
                            "Sorry  there is no product yet ",
                            style: TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                          )
                        ],
                      ));
                    });
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    ));
  }
}

class ProductsData {
  ProductsData(this.label, this.percentage);
  final String label;
  final int percentage;
}
