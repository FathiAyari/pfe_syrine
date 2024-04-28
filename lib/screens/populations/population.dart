import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pfe_syrine/services/PopulationConfig_services.dart';
import 'package:pfe_syrine/services/populations_services.dart';

import '../../components/will_pop.dart';
import '../../constants.dart';
import '../../input_filed.dart';
import '../../models/population.dart';
import '../companies/components/input_field.dart';

class PopulationScreen extends StatefulWidget {
  const PopulationScreen({Key? key}) : super(key: key);

  @override
  State<PopulationScreen> createState() => _PopulationScreenState();
}

class _PopulationScreenState extends State<PopulationScreen> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          createPopulation(context, () {
            setState(() {});
          });
        },
        backgroundColor: const Color(0xff066163),
        child: const Icon(
          Icons.add,
          size: 25.0,
        ),
      ),
      appBar: AppBar(
        title: const Text("Populations"),
        centerTitle: true,
        backgroundColor: Color(0xff7ea4f3),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
            future: PopulationsServices().getpopulation(),
            builder: (contect, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Population> populations = List<Population>.from(snapshot.data);
                if (snapshot.data.length != 0) {
                  return ListView.builder(
                    itemCount: populations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 0,
                              color: Color.fromARGB(255, 228, 227, 225),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      if (populations[index].populationConfig == null) {
                                        setState(() {
                                          startTime = DateTime.now();
                                          endTime = DateTime.now();
                                        });
                                        createPopulationConfig(context, populations[index], () {
                                          setState(() {});
                                        });
                                      } else {
                                        updatePopulationConfig(context, populations[index], () {
                                          setState(() {});
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 6.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Population Name: ${populations[index].name.toUpperCase()}",
                                            style: const TextStyle(
                                                fontSize: 20.0, fontWeight: FontWeight.w400, fontFamily: "NunitoBold"),
                                          ),
                                          Text(
                                            "Created At: ${DateFormat("yyyy-MM-dd").format(populations[index].created_at)}",
                                            style: const TextStyle(
                                                fontSize: 20.0, fontWeight: FontWeight.w400, fontFamily: "NunitoBold"),
                                          ),
                                          populations[index].populationConfig != null
                                              ? Text(
                                                  "Population Config: Configured",
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: "NunitoBold"),
                                                )
                                              : Text(
                                                  "Population Config: Not Yet",
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: "NunitoBold",
                                                      color: Colors.red),
                                                ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                onPressed: () {
                                                  NAlertDialog(
                                                    title: WillPopTitle("You want to delete this company ?", context),
                                                    actions: [
                                                      Negative(),
                                                      Positive(() {
                                                        PopulationsServices.deletePopulation(populations[index].id, () {
                                                          setState(() {});
                                                        }).then((value) {
                                                          if (value) {
                                                            Navigator.pop(context);
                                                            Fluttertoast.showToast(
                                                                msg: "Company deleted successfully",
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
                                                label: Text("Delete"),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  upatePopulation(context, populations[index], () {
                                                    setState(() {});
                                                  });
                                                },
                                                icon: Icon(Icons.edit),
                                                label: Text("Edit"),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ))));
                    },
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
                              "There is no orders in hold yet ",
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

  upatePopulation(BuildContext context, Population population, VoidCallback onPressed) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    nameController.text = population.name;
    bool isLoading = false;

    bool isDone = false;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                height: Constants.screenHeight * 0.6,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 10),
                  child: isDone
                      ? doneSupply(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                    width: Constants.screenWidth * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Edit Population ", style: TextStyle(fontSize: 20, color: Color(0xff4d5251))),
                                  ),
                                  InputField("Population Name", nameController),
                                ],
                              ),
                            ),
                            isLoading
                                ? Lottie.asset(
                                    "assets/loading.json",
                                    height: Constants.screenWidth * 0.15,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text("Cancel"),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              PopulationsServices().updatePopulation({"name": nameController.text}, population.id,
                                                  () {
                                                onPressed();
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Population updated successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                setState(() {
                                                  isLoading = false;
                                                  isDone = true;
                                                });
                                              });
                                            }
                                          },
                                          child: Text("Confirm"))
                                    ],
                                  ),
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

  createPopulation(BuildContext context, VoidCallback onPressed) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    bool isLoading = false;

    bool isDone = false;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                height: Constants.screenHeight * 0.6,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 10),
                  child: isDone
                      ? doneSupply(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                    width: Constants.screenWidth * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Create Population ", style: TextStyle(fontSize: 20, color: Color(0xff4d5251))),
                                  ),
                                  InputField("Population Name", nameController),
                                ],
                              ),
                            ),
                            isLoading
                                ? Lottie.asset(
                                    "assets/loading.json",
                                    height: Constants.screenWidth * 0.15,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text("Cancel"),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              PopulationsServices().createPopulation({"name": nameController.text}, () {
                                                onPressed();
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Population updated successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                setState(() {
                                                  isLoading = false;
                                                  isDone = true;
                                                });
                                              });
                                            }
                                          },
                                          child: Text("Confirm"))
                                    ],
                                  ),
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

  createPopulationConfig(BuildContext context, Population population, VoidCallback onPressed) {
    final _formKey = GlobalKey<FormState>();
    List ldays = [];
    List<DayInWeek> _days = [
      DayInWeek(
        dayKey: "L",
        "L",
      ),
      DayInWeek(
        dayKey: "M",
        "M",
      ),
      DayInWeek(
        dayKey: "M",
        "M",
      ),
      DayInWeek(
        dayKey: "J",
        "J",
      ),
      DayInWeek(
        dayKey: "V",
        "V",
      ),
      DayInWeek(
        dayKey: "S",
        "S",
      ),
      DayInWeek(
        dayKey: "D",
        "D",
      ),
    ];
    bool isLoading = false;

    bool isDone = false;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                height: Constants.screenHeight * 0.6,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 10),
                  child: isDone
                      ? doneSupply(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                    width: Constants.screenWidth * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Create PopulationConfig ",
                                        style: TextStyle(fontSize: 20, color: Color(0xff4d5251))),
                                  ),
                                  MyInputfiled(
                                    title: "Start Time",
                                    hint: DateFormat("yyyy-MM-dd").format(startTime),
                                    widget: IconButton(
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2055))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              startTime = value;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  MyInputfiled(
                                    title: "End Time",
                                    hint: DateFormat("yyyy-MM-dd").format(endTime),
                                    widget: IconButton(
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2055))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              endTime = value;
                                              print(value.runtimeType);
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectWeekDays(
                                      border: false,
                                      boxDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          colors: [const Color(0xFFE55CE4), const Color(0xFFBB75FB)],
                                          tileMode: TileMode.repeated, // repeats the gradient over the canvas
                                        ),
                                      ),
                                      onSelect: (values) {
                                        ldays = values;
                                      },
                                      days: _days,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isLoading
                                ? Lottie.asset(
                                    "assets/loading.json",
                                    height: Constants.screenWidth * 0.15,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text("Cancel"),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () async {
                                            if (startTime.isBefore(endTime)) {
                                              if (ldays.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg: "You have to select ay least one day",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                PopulationConfigServices().createPopulationConfig({
                                                  "start": startTime.toString(),
                                                  "end": endTime.toString(),
                                                  "days": ldays,
                                                  "population_id": population.id
                                                }, onPressed).then((value) {
                                                  setState(() {
                                                    isLoading = false;
                                                    isDone = true;
                                                  });
                                                });
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Start date must be before End date",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          },
                                          child: Text("Confirm"))
                                    ],
                                  ),
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

  updatePopulationConfig(BuildContext context, Population population, VoidCallback onPressed) {
    final _formKey = GlobalKey<FormState>();
    bool changed = false;
    bool isLoading = false;

    bool isDone = false;
    List<DayInWeek> _days = [
      DayInWeek(
        dayKey: "L",
        "L",
      ),
      DayInWeek(
        dayKey: "M",
        "M",
      ),
      DayInWeek(
        dayKey: "M",
        "M",
      ),
      DayInWeek(
        dayKey: "J",
        "J",
      ),
      DayInWeek(
        dayKey: "V",
        "V",
      ),
      DayInWeek(
        dayKey: "S",
        "S",
      ),
      DayInWeek(
        dayKey: "D",
        "D",
      ),
    ];
    List myDays = population.populationConfig!.days;
    for (int i = 0; i < myDays.length; i++) {
      for (int j = 0; j < _days.length; j++) {
        if (myDays[i] == _days[j].dayName) {
          _days[j].isSelected = true;
        }
      }
    }
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                height: Constants.screenHeight * 0.6,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 10),
                  child: isDone
                      ? doneSupply(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                    width: Constants.screenWidth * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Update PopulationConfig ",
                                        style: TextStyle(fontSize: 20, color: Color(0xff4d5251))),
                                  ),
                                  MyInputfiled(
                                    title: "Start Time",
                                    hint: DateFormat("yyyy-MM-dd").format(population.populationConfig!.start).toString(),
                                    widget: IconButton(
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2055))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              startTime = value;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  MyInputfiled(
                                    title: "End Time",
                                    hint: DateFormat("yyyy-MM-dd").format(population.populationConfig!.end).toString(),
                                    widget: IconButton(
                                      icon: const Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2055))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              endTime = value;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectWeekDays(
                                      border: false,
                                      boxDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          colors: [const Color(0xFFE55CE4), const Color(0xFFBB75FB)],
                                          tileMode: TileMode.repeated, // repeats the gradient over the canvas
                                        ),
                                      ),
                                      onSelect: (values) {
                                        myDays = values;
                                      },
                                      days: _days,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isLoading
                                ? Lottie.asset(
                                    "assets/loading.json",
                                    height: Constants.screenWidth * 0.15,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text("Cancel"),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            PopulationConfigServices()
                                                .deletePopulationConfig(population.populationConfig!.id, onPressed)
                                                .then((value) {
                                              setState(() {
                                                isLoading = false;
                                                Fluttertoast.showToast(
                                                    msg: "Configuration has been deleted",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                Navigator.pop(context);
                                              });
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text("Delete"),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () async {
                                            if (startTime.isBefore(endTime)) {
                                              if (myDays.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg: "You have to select ay least one day",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                PopulationConfigServices().updatePopulation({
                                                  "start": startTime.toString(),
                                                  "end": endTime.toString(),
                                                  "days": myDays,
                                                }, population.populationConfig!.id, onPressed).then((value) {
                                                  setState(() {
                                                    isLoading = false;
                                                    Fluttertoast.showToast(
                                                        msg: "Configuration has been update",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.grey,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    Navigator.pop(context);
                                                  });
                                                });
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Start date must be before End date",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          },
                                          child: Text("Update"))
                                    ],
                                  ),
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

  Column doneSupply(BuildContext context) {
    return Column(
      children: [
        Lottie.asset("assets/success.json", height: Constants.screenHeight * 0.1, repeat: false),
        Text(
          "",
          style: TextStyle(fontSize: Constants.screenHeight * 0.02),
        ),
        SizedBox(
          height: Constants.screenHeight * 0.08,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Close"),
            ))
      ],
    );
  }
}
