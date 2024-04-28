import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/constants.dart';

import '../../models/historic_stock.dart';
import '../../services/stock_history_services.dart';

class StockHistory extends StatefulWidget {
  const StockHistory({Key? key}) : super(key: key);

  @override
  State<StockHistory> createState() => _StockHistoryState();
}

class _StockHistoryState extends State<StockHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff7ea4f3),
          title: Text("Stock History"),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
            future: StockHistoryServices().getStockHistory(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<StockHistoryModel> stockHistory = [];
                for (var data in snapshot.data) {
                  stockHistory.add(data);
                }
                if (snapshot.data.length != 0) {
                  return ListView.builder(
                      itemCount: stockHistory.length,
                      itemBuilder: (context, index) {
                        return buildHistoryWidget(stockHistory[index]);
                      });
                } else {
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Center(
                            child: Column(
                          children: [
                            Lottie.asset("assets/empty.json"),
                            Text(
                              "There is no history yet ",
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
      ),
    );
  }

  buildHistoryWidget(StockHistoryModel stockHistoryModel) {
    if (stockHistoryModel.type == "supply") {
      return Container(
        height: Constants.screenHeight * 0.15,
        child: Card(
          elevation: 2,
          child: Row(
            children: [
              Container(
                color: Color(0xff69e5c8),
                width: Constants.screenWidth * 0.03,
              ),
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${stockHistoryModel.body}",
                        style: TextStyle(fontFamily: "NunitoBold", color: Color(0xff69e5c8)),
                      ),
                    ],
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.arrow_downward_outlined,
                  color: Color(0xff69e5c8),
                ),
                decoration: BoxDecoration(color: Color(0xff69e5c8).withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
              )
            ],
          ),
        ),
      );
    } else if (stockHistoryModel.type == "order") {
      return Container(
        height: Constants.screenHeight * 0.15,
        child: Card(
          elevation: 2,
          child: Row(
            children: [
              Container(
                color: Colors.red,
                width: Constants.screenWidth * 0.03,
              ),
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${stockHistoryModel.body}",
                    style: TextStyle(fontFamily: "NunitoBold", color: Colors.red),
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.arrow_upward_sharp,
                  color: Colors.red,
                ),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: Constants.screenHeight * 0.15,
        child: Card(
          elevation: 2,
          child: Row(
            children: [
              Container(
                color: Colors.green,
                width: Constants.screenWidth * 0.03,
              ),
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${stockHistoryModel.body}",
                    style: TextStyle(fontFamily: "NunitoBold", color: Colors.green),
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
              )
            ],
          ),
        ),
      );
    }
  }
}
