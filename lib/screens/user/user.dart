import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/screens/planning/planning.dart';
import 'package:pfe_syrine/screens/user/components/add_user.dart';
import 'package:pfe_syrine/services/user_services.dart';

import '../../constants.dart';
import '../../models/user.dart';
import 'components/update_user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff7ea4f3),
        onPressed: () {
          Get.to(AddUser());
        },
        child: Icon(Icons.add),
      ),
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
        backgroundColor: Color(0xff7ea4f3),
        title: Text("Users"),
        centerTitle: true,
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
                  List<User> users = [];
                  List<User> data = snapshot.data;
                  for (var data in data) {
                    users.add(data);
                  }
                  if (snapshot.data.length != 0) {
                    return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Slidable(
                                key: ValueKey(1),
                                startActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: "Update",
                                      onPressed: (BuildContext context) {
                                        Get.to(UpdateUser(
                                          user: users[index],
                                        ));
                                      },
                                    ),
                                    SlidableAction(
                                      backgroundColor: Color(0xffed6591),
                                      foregroundColor: Colors.white,
                                      icon: Icons.cancel,
                                      label: "Cancel",
                                      onPressed: (context) async {},
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xff7ea4f3)),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ExpansionTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Color(0xff7ea4f3),
                                    ),
                                    title: Text(
                                      "${users[index].firstname.toUpperCase()} ${users[index].lastname.toUpperCase()}",
                                      style: TextStyle(fontFamily: "NunitoBold", fontSize: 16.0, fontWeight: FontWeight.w500),
                                    ),
                                    children: <Widget>[
                                      Container(
                                        child: ListTile(
                                          title: Text(
                                            "Created At : ${DateFormat('dd/MM/yyyy').format(users[index].created_at)}",
                                            style: TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          title: Text(
                                            "Role : ${users[index].role}",
                                            style: TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          title: Text(
                                            "Population : ${users[index].population}",
                                            style: TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          title: Text(
                                            "Email : ${users[index].email}",
                                            style: TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                                "There is no user yet ",
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
      ),
    ));
  }
}
