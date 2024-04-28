import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';
import '../../../models/activite.dart';
import '../../../services/activities_services.dart';

class FinishedActivities extends StatefulWidget {
  final int status;
  const FinishedActivities({Key? key, required this.status}) : super(key: key);

  @override
  State<FinishedActivities> createState() => _UnAssignedActivitiesState();
}

class _UnAssignedActivitiesState extends State<FinishedActivities> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder(
          future: ActivitiesServices().getActivities(widget.status),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Activite> acts = [];
              snapshot.data.map((json) {
                acts.add(json);
              }).toList();

              if (acts.length != 0) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Constants.screenWidth * 0.02, vertical: Constants.screenHeight * 0.01),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(acts[index].color),
                            boxShadow: [
                              BoxShadow(
                                color: Color(acts[index].color).withOpacity(0.5),

                                spreadRadius: 4,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          height: Constants.screenHeight * 0.16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Activity Name : ${acts[index].name}",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Activity Type : ${acts[index].type}",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Activity Description : ${acts[index].description}",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: acts.length,
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
                            "There is no finished activity  yet ",
                            style: TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                          )
                        ],
                      ));
                    });
              }
            } else {
              return Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1));
            }
          }),
    );
  }
}
