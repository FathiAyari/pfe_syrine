import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/screens/planning/components/user_plannings.dart';

import '../../../constants.dart';
import '../../../models/user.dart';
import '../../../services/user_services.dart';

class PlanningPerUser extends StatefulWidget {
  const PlanningPerUser({Key? key}) : super(key: key);

  @override
  State<PlanningPerUser> createState() => _PlanningPerUserState();
}

var user = GetStorage().read("user");

class _PlanningPerUserState extends State<PlanningPerUser> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Plannings"),
        centerTitle: true,
        backgroundColor: Color(0xff7ea4f3),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: UserServices().getusers(user['id']),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<User> users = List<User>.from(snapshot.data);
                  if (snapshot.data.length != 0) {
                    return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xff7ea4f3)),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => UserPlannings(
                                              user: users[index],
                                            ),
                                          ));
                                    },
                                    title: Text(
                                      "${users[index].firstname.toUpperCase()} ${users[index].lastname.toUpperCase()}",
                                      style: TextStyle(fontFamily: "NunitoBold", fontSize: 16.0, fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xff7ea4f3),
                                    ),
                                  )),
                            ),
                          );
                        });
                  } else {
                    return Center(
                        child: Column(
                      children: [
                        Lottie.asset("assets/empty.json"),
                        Text(
                          "Sorry  there is no user yet ",
                          style: TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                        )
                      ],
                    ));
                  }
                } else {
                  return Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1));
                }
              },
            )),
      ),
    ));
  }
}
