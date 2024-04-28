import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';
import '../../../models/notifications.dart';
import '../../../services/notifications_services.dart';
import '../planning.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text("Notifications"),
        backgroundColor: Color(0xff7ea4f3),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
            future: NotifServices().getNotifs(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Notif> notif = [];
                List<Notif> data = snapshot.data;
                for (var data in data) {
                  notif.add(data);
                }
                if (snapshot.data.length != 0) {
                  return ListView.builder(
                      itemCount: notif.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(width: double.infinity, child: buildHistoryWidget(notif[index])),
                        );
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
                              "There is no notifications yet ",
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
          )),
    ));
  }

  buildHistoryWidget(Notif notif) {
    if (notif.type == "start") {
      return Container(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${notif.body}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Colors.green),
                        ),
                        Text(
                          "${DateFormat("yyyy-MM-dd HH:mm").format(notif.createdAt)}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.start,
                    color: Colors.green,
                  ),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                )
              ],
            ),
          ),
        ),
      );
    } else if (notif.type == "summerize") {
      return Container(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  color: Color(0xffed6591),
                  width: Constants.screenWidth * 0.03,
                ),
                Expanded(
                    child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${notif.body}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Color(0xffed6591)),
                        ),
                        Text(
                          "${DateFormat("yyyy-MM-dd HH:mm").format(notif.createdAt)}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Color(0xffed6591)),
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.summarize_outlined,
                    color: Color(0xffed6591),
                  ),
                  decoration: BoxDecoration(color: Color(0xffed6591).withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                )
              ],
            ),
          ),
        ),
      );
    } else if (notif.type == "lack") {
      return Container(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${notif.body}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Colors.amber),
                        ),
                        Text(
                          "${DateFormat("yyyy-MM-dd HH:mm").format(notif.createdAt)}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(Icons.warning_amber, color: Colors.amber),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${notif.body}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Colors.blueAccent),
                        ),
                        Text(
                          "${DateFormat("yyyy-MM-dd HH:mm").format(notif.createdAt)}",
                          style: TextStyle(fontFamily: "NunitoBold", color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(Icons.close_fullscreen, color: Colors.blueAccent),
                  decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
