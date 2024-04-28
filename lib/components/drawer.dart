import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pfe_syrine/components/will_pop.dart';
import 'package:pfe_syrine/constants.dart';
import 'package:pfe_syrine/screens/activite/activite.dart';

import '../screens/companies/company.dart';
import '../screens/general_historic/general_historic.dart';
import '../screens/holidays/holidays_managment.dart';
import '../screens/holidays/my_holidays.dart';
import '../screens/login/login.dart';
import '../screens/planning/add_task.dart';
import '../screens/planning/components/my_plannings.dart';
import '../screens/planning/components/planning_per_user.dart';
import '../screens/planning/planning.dart';
import '../screens/populations/population.dart';
import '../screens/statistics/StatisticsScreen.dart';
import '../screens/stock/home_stock.dart';
import '../screens/stock/stock_history.dart';
import '../screens/user/user.dart';

class Mydrawer extends StatefulWidget {
  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  //getuser info
  var userData = GetStorage().read("user");

  @override
  void initState() {
    super.initState();
  }

  Widget checkRole(String role) {
    switch (role) {
      case 'Super Admin':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings_rounded, color: Colors.white),
            Text(
              userData != null ? '${userData['role']}' : '',
              style: TextStyle(fontFamily: "NunitoBold", color: Colors.white),
            )
          ],
        );
      case 'Admin':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings_outlined, color: Colors.white),
            Text(
              userData != null ? '${userData['role']}' : '',
              style: TextStyle(fontFamily: "NunitoBold", color: Colors.white),
            )
          ],
        );

      case 'Stock Manager':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storage_sharp, color: Colors.white),
            Text(
              userData != null ? '${userData['role']}' : '',
              style: TextStyle(fontFamily: "NunitoBold", color: Colors.white),
            )
          ],
        );

      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.computer, color: Colors.white),
            Text(
              userData != null ? '${userData['role']}' : '',
              style: TextStyle(fontFamily: "NunitoBold", color: Colors.white),
            )
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          child: Container(
              width: 150,
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: Constants.screenHeight * 0.1,
                                width: Constants.screenWidth * 0.2,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffed6591).withOpacity(0.5),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                '${userData['firstname']} ${userData['lastname']}'.toUpperCase(),
                                style: TextStyle(fontFamily: "NunitoBold", color: Colors.white),
                              ),
                              Text(
                                userData != null ? '${userData['email']}' : '',
                                style: TextStyle(fontFamily: "NunitoBold", color: Colors.white),
                              ),
                              checkRole(userData['role']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: Constants.screenHeight * 0.07,
                            width: Constants.screenWidth * 0.13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffed6591).withOpacity(0.5),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                size: 35,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height: Constants.screenHeight * 0.22,
                    decoration: const BoxDecoration(
                      color: Color(0xffb67cf3),
                    ),
                  ),
                  CustomListTile(Icons.calendar_month, () {
                    if (userData['role'] == "Stock Manager" || userData['role'] == "Employee") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyPlannings(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => CalendarPage(),
                          ));
                    }
                  }, 'Calendar'),
                  if (userData['role'] == "Stock Manager" || userData['role'] == "Employee") ...[
                    CustomListTile(Icons.compare_arrows, () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyHolidays(),
                          ));
                    }, 'My Holidays'),
                  ],
                  if (userData['role'] == "Admin" || userData['role'] == "Super Admin") ...[
                    CustomListTile(Icons.compare_arrows, () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HolidaysManagment(),
                          ));
                    }, 'Holidays Managment'),
                  ],
                  if (userData['role'] == "Admin" ||
                      userData['role'] == "Super Admin" ||
                      userData['role'] == "Stock Manager") ...[
                    CustomListTile(Icons.query_stats, () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Statistics(),
                          ));
                    }, 'Statistics'),
                  ],
                  if (userData['role'] == "Admin" || userData['role'] == "Super Admin") ...[
                    CustomListTile(Icons.history, () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => GeneralHistoric(),
                          ));
                    }, 'General history'),
                  ],
                  if (userData['role'] == "Admin" ||
                      userData['role'] == "Super Admin" ||
                      userData['role'] == "Stock Manager") ...[
                    ExpansionTile(
                      leading: Icon(
                        Icons.production_quantity_limits_rounded,
                        color: Color(0xff7ea4f3),
                      ),
                      collapsedIconColor: Color(0xff7ea4f3),
                      iconColor: Color(0xff7ea4f3),
                      title: Text(
                        'Stock managment',
                        style: TextStyle(fontFamily: "NunitoBold", color: Color(0xff7ea4f3)),
                      ),
                      children: [
                        CustomListTile(Icons.storage, () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => HomeStock(),
                              ));
                        }, 'Managment'),
                        CustomListTile(Icons.history_rounded, () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => StockHistory(),
                              ));
                        }, 'History'),
                      ],
                    ),
                  ],
                  if (userData['role'] == "Admin" || userData['role'] == "Super Admin") ...[
                    ExpansionTile(
                        leading: Icon(
                          Icons.person,
                          color: Color(0xff7ea4f3),
                        ),
                        collapsedIconColor: Color(0xff7ea4f3),
                        iconColor: Color(0xff7ea4f3),
                        title: Text(
                          'Users',
                          style: TextStyle(color: Color(0xff7ea4f3), fontFamily: "NunitoBold"),
                        ),
                        children: [
                          CustomListTile(Icons.person_search, () {
                            Navigator.pop(context);
                            if (userData['role'] == 'Admin' || userData['role'] == 'Super Admin') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => UsersScreen(),
                                  ));
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Vous n'avez pas l'accée pour accéder à cette interface"),
                                duration: const Duration(seconds: 1),
                              ));
                            }
                          }, 'List users'),
                        ]),
                  ],
                  if (userData['role'] == "Admin" || userData['role'] == "Super Admin") ...[
                    ExpansionTile(
                        leading: Icon(
                          Icons.task,
                          color: Color(0xff7ea4f3),
                        ),
                        collapsedIconColor: Color(0xff7ea4f3),
                        iconColor: Color(0xff7ea4f3),
                        title: Text(
                          'Plannings',
                          style: TextStyle(
                            color: Color(0xff7ea4f3),
                          ),
                        ),
                        children: [
                          CustomListTile(Icons.add_task, () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => AddTaskPage(),
                                ));
                          }, 'Add Planning'),
                          CustomListTile(Icons.format_list_numbered, () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => PlanningPerUser(),
                                ));
                          }, 'Plannings'),
                        ]),
                  ],
                  if (userData['role'] == "Admin" || userData['role'] == "Super Admin") ...[
                    ExpansionTile(
                        leading: Icon(
                          Icons.local_activity,
                          color: Color(0xff7ea4f3),
                        ),
                        collapsedIconColor: Color(0xff7ea4f3),
                        iconColor: Color(0xff7ea4f3),
                        title: Text(
                          'Activites',
                          style: TextStyle(color: Color(0xff7ea4f3), fontFamily: "NunitoBold"),
                        ),
                        children: [
                          CustomListTile(Icons.local_activity_sharp, () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => ActiviteScreen(),
                                ));
                          }, 'Activities'),
                        ]),
                  ],
                  if (userData['role'] == "Admin" || userData['role'] == "Super Admin") ...[
                    ExpansionTile(
                        leading: Icon(
                          Icons.comment,
                          color: Color(0xff7ea4f3),
                        ),
                        collapsedIconColor: Color(0xff7ea4f3),
                        iconColor: Color(0xff7ea4f3),
                        title: Text(
                          'Populations',
                          style: TextStyle(
                            color: Color(0xff7ea4f3),
                          ),
                        ),
                        children: [
                          CustomListTile(Icons.add_comment, () {
                            Navigator.pop(context);
                            if (userData['role'] == 'Admin' || userData['role'] == 'Super Admin') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => PopulationScreen(),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Vous n'avez pas l'accée pour accéder à cette interface"),
                                duration: const Duration(seconds: 1),
                              ));
                            }
                          }, 'List Populations'),
                        ]),
                  ],
                  if (userData['role'] == "Admin" || userData['role'] == "Super Admin") ...[
                    ExpansionTile(
                        leading: Icon(
                          Icons.work,
                          color: Color(0xff7ea4f3),
                        ),
                        collapsedIconColor: Color(0xff7ea4f3),
                        iconColor: Color(0xff7ea4f3),
                        title: Text(
                          'Companies',
                          style: TextStyle(
                            color: Color(0xff7ea4f3),
                          ),
                        ),
                        children: [
                          CustomListTile(Icons.work_history, () {
                            print(userData['role']);
                            Navigator.pop(context);
                            if (userData['role'] == 'Super Admin' || userData['role'] == 'Admin') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => CompanyScreen(),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Vous n'avez pas l'accée pour accéder à cette interface"),
                                duration: const Duration(seconds: 1),
                              ));
                            }
                          }, 'Companies'),
                        ]),
                  ],
                  CustomListTile(Icons.logout, () async {
                    NAlertDialog(
                      title: WillPopTitle("You want to sign out ?", context),
                      actions: [
                        Negative(),
                        Positive(() {
                          GetStorage().remove("user");

                          // Then close the drawer
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginScreen(),
                              ));
                        })
                      ],
                      blur: 2,
                    ).show(context, transitionType: DialogTransitionType.Bubble);
                  }, 'Déconnexion'),
                ],
              ))),
    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  VoidCallback onTap;

  CustomListTile(this.icon, this.onTap, this.text);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Color.fromRGBO(19, 124, 163, 64),
          onTap: onTap,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Color(0xff7ea4f3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontFamily: "NunitoBold", color: Color(0xff7ea4f3), fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right, color: Color(0xff7ea4f3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
