import 'package:flutter/material.dart';

import '../widgets/week_view_widget.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({Key? key}) : super(key: key);

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: _addEvent,
      ),
      body: WeekViewWidget(),
    );
  }

  Future<void> _addEvent() async {
    // final event =
    //     await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
    //   withDuration: true,
    // ));
    // if (event == null) return;
    // CalendarControllerProvider.of<Event>(context).controller.add(event);
  }
}
