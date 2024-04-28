import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pfe_syrine/screens/splash_screen/splash_screen.dart';
import 'package:pfe_syrine/screens/user/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //
  await GetStorage.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        scrollBehavior: ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        routes: <String, WidgetBuilder>{
          "/": (BuildContext context) => new SplashScreen(),
          "/userscreen": (BuildContext context) => new UsersScreen(),
        });
  }
}
