import 'package:flutter/material.dart';
import 'package:pfe_syrine/screens/holidays/holiday_tab.dart';
import 'package:pfe_syrine/screens/planning/components/my_plannings.dart';

import '../../constants.dart';
import 'add_request.dart';

class MyHolidays extends StatefulWidget {
  const MyHolidays({Key? key}) : super(key: key);

  @override
  State<MyHolidays> createState() => _MyHolidaysState();
}

class _MyHolidaysState extends State<MyHolidays> with TickerProviderStateMixin {
  late TabController _tabController;
  int color = 0;
  List<Color> colors = [Color(0xfff0a55f), Color(0xffed6591), Color(0xff69e5c8)];
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {
          color = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                    icon: Icon(Icons.create_new_folder),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(15),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => AddRequestHoliday(),
                          ));
                    },
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Add Request"),
                    )),
              ),
            ),
            appBar: AppBar(
              title: Text("My Holidays"),
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyPlannings(),
                      ));
                },
                icon: Icon(Icons.arrow_back),
              ),
              centerTitle: true,
              backgroundColor: Color(0xff7ea4f3),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01, horizontal: Constants.screenWidth * 0.01),
                    child: Container(
                      child: TabBar(
                        splashBorderRadius: BorderRadius.circular(20),
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        unselectedLabelColor: Color(0xff7ea4f3),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colors[color],
                        ),
                        controller: _tabController,
                        tabs: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                vertical: Constants.screenHeight * 0.009,
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Text("Pending", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                          Container(
                              padding: EdgeInsets.symmetric(
                                vertical: Constants.screenHeight * 0.009,
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Text("Refused", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                          Container(
                              padding: EdgeInsets.symmetric(
                                vertical: Constants.screenHeight * 0.009,
                              ),
                              child: Text("Accepted", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: [
                      HolidayTab(
                        status: 0,
                      ),
                      HolidayTab(
                        status: -1,
                      ),
                      HolidayTab(
                        status: 1,
                      ),
                    ],
                  ))
                ],
              ),
            )));
  }
}
