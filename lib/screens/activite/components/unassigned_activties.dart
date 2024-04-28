import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pfe_syrine/models/activite.dart';
import 'package:pfe_syrine/services/activities_services.dart';

import '../../../components/will_pop.dart';
import '../../../constants.dart';
import 'edit_activity.dart';

class UnAssignedActivities extends StatefulWidget {
  final int status;
  const UnAssignedActivities({Key? key, required this.status}) : super(key: key);

  @override
  State<UnAssignedActivities> createState() => _UnAssignedActivitiesState();
}

class _UnAssignedActivitiesState extends State<UnAssignedActivities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
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
                  return Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
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
                            child: ExpansionTile(
                              collapsedIconColor: Colors.white,
                              iconColor: Colors.white,
                              title: Column(
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
                                ],
                              ),
                              children: [
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      "Activity Description : ${acts[index].description}",
                                      style: TextStyle(
                                          fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            NAlertDialog(
                                              title: WillPopTitle("You want to delete this activity ?", context),
                                              actions: [
                                                Negative(),
                                                Positive(() {
                                                  ActivitiesServices.deleteActivity(acts[index].id, () {
                                                    setState(() {});
                                                  }).then((value) {
                                                    if (value) {
                                                      Navigator.pop(context);
                                                      Fluttertoast.showToast(
                                                          msg: "Activity deleted successfully",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Color(0xff69e5c8),
                                                          textColor: Colors.white,
                                                          fontSize: 16.0);
                                                    } else {
                                                      Navigator.pop(context);
                                                      Fluttertoast.showToast(
                                                          msg: "Error has been occured",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.red,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  });
                                                })
                                              ],
                                              blur: 2,
                                            ).show(context, transitionType: DialogTransitionType.Bubble);
                                          },
                                          icon: Icon(Icons.delete),
                                          label: Text("Delete")),
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => EditActivity(
                                                      activite: acts[index],
                                                    )));
                                          },
                                          icon: Icon(Icons.edit),
                                          label: Text("Edit")),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: acts.length,
                    ),
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
                              "There is no unassigned activity yet ",
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
      ),
    );
  }
}
