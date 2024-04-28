import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/services/general_history_services.dart';

import '../../constants.dart';
import '../../models/general_historic.dart';

class GeneralHistoric extends StatefulWidget {
  const GeneralHistoric({Key? key}) : super(key: key);

  @override
  State<GeneralHistoric> createState() => _GeneralHistoricState();
}

class _GeneralHistoricState extends State<GeneralHistoric> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7ea4f3),
        title: Text("General History"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: GeneralHistoricServices.getHistorics(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<GeneralHistoricModel> generalHistorics = [];
              for (var data in snapshot.data) {
                generalHistorics.add(data);
              }
              if (snapshot.data.length != 0) {
                return ListView.builder(
                    itemCount: generalHistorics.length,
                    itemBuilder: (context, index) {
                      return buildHistoryWidget(generalHistorics[index]);
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
                            "There is no general history yet ",
                            style: TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                          )
                        ],
                      ));
                    });
              }
            } else {
              return Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1));
            }
          },
        ),
      ),
    ));
  }

  buildHistoryWidget(GeneralHistoricModel generalHistoric) {
    if (generalHistoric.type == "create") {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${generalHistoric.body}",
                        style: TextStyle(
                          fontFamily: "NunitoBold",
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.create_new_folder,
                  color: Colors.green,
                ),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
              )
            ],
          ),
        ),
      );
    } else if (generalHistoric.type == "delete") {
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
                    "${generalHistoric.body}",
                    style: TextStyle(fontFamily: "NunitoBold", color: Colors.red),
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
              )
            ],
          ),
        ),
      );
    } else if (generalHistoric.type == "plancreate") {
      return Container(
        height: Constants.screenHeight * 0.15,
        child: Card(
          elevation: 2,
          child: Row(
            children: [
              Container(
                color: Colors.blueAccent,
                width: Constants.screenWidth * 0.03,
              ),
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${generalHistoric.body}",
                    style: TextStyle(fontFamily: "NunitoBold", color: Colors.blueAccent),
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.task,
                  color: Colors.blueAccent,
                ),
                decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
              )
            ],
          ),
        ),
      );
    } else if (generalHistoric.type == "plancdelete") {
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
                    "${generalHistoric.body}",
                    style: TextStyle(fontFamily: "NunitoBold", color: Colors.red),
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.delete_forever_outlined,
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
                color: Color(0xff7ea4f3),
                width: Constants.screenWidth * 0.03,
              ),
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${generalHistoric.body}",
                    style: TextStyle(fontFamily: "NunitoBold", color: Color(0xff7ea4f3)),
                  ),
                ),
              )),
              Container(
                height: 50,
                width: 50,
                child: Icon(Icons.add, color: Color(0xff7ea4f3)),
                decoration: BoxDecoration(color: Color(0xff7ea4f3).withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
              )
            ],
          ),
        ),
      );
    }
  }
}
