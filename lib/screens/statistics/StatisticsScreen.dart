import 'package:flutter/material.dart';
import 'package:pfe_syrine/screens/statistics/widgets/orders_screen.dart';
import 'package:pfe_syrine/screens/statistics/widgets/plannings_widget.dart';
import 'package:pfe_syrine/screens/statistics/widgets/products_widget.dart';
import 'package:pfe_syrine/screens/statistics/widgets/stuff_widget.dart';

import 'components/list_view_item_widget.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7ea4f3),
        title: Text("Statistics"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListViewItem(StuffScreen(), "assets/stuff.png", "Stuff", Color(0xff7ea4f3), context),
          ListViewItem(ProductsScreen(), "assets/product.png", "Products", Color(0xfff0a55f), context),
          ListViewItem(OrdersScreen(), "assets/orders.png", "Orders", Color(0xffed6591), context),
          ListViewItem(PlanningScreen(), "assets/activity.png", "Planning", Color(0xff69e5c8), context),
        ],
      ),
    ));
  }
}
