import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'admin/admin_holiday_tab.dart';

class HolidaysManagment extends StatefulWidget {
  const HolidaysManagment({Key? key}) : super(key: key);

  @override
  State<HolidaysManagment> createState() => _HolidaysManagmentState();
}

class _HolidaysManagmentState extends State<HolidaysManagment> with TickerProviderStateMixin {
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
      appBar: AppBar(
        title: Text("Holidays Managment"),
        centerTitle: true,
        backgroundColor: Color(0xff7ea4f3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01, horizontal: Constants.screenWidth * 0.01),
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
                AdminHolidayTab(
                  status: 0,
                ),
                AdminHolidayTab(
                  status: -1,
                ),
                AdminHolidayTab(
                  status: 1,
                ),
              ],
            ))
          ],
        ),
      ),
    ));
  }
}
